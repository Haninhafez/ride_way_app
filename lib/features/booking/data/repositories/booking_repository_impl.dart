import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/error/firebase_exception_mapper.dart';

import '../../domain/entities/booking_summary.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/route_stop.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/train_detail.dart';
import '../../domain/entities/travel_class.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_firestore_data_source.dart';
import '../models/passenger_model.dart';
import '../models/route_stop_dto.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingFirestoreDataSource firestoreDataSource;

  const BookingRepositoryImpl({required this.firestoreDataSource});


  @override
  Future<TrainDetail> getTrainDetails(String trainId) async {
    try {
      final dto = await firestoreDataSource.fetchTripWithTrainDetails(trainId);
      log('[BookingRepo] getTrainDetails dto=$dto');

      final resolvedDto = await _resolveStationNames(dto);
      log('[BookingRepo] getTrainDetails resolvedDto=$resolvedDto');

      return resolvedDto;
    } on FirebaseException catch (e) {
      final failure = mapFirebaseException(e);
      log('[BookingRepo] getTrainDetails error: ${failure.message}');

      throw Exception(failure.message);
    } catch (e) {
      log('[BookingRepo] getTrainDetails unknown error: $e');
      rethrow;
    }
  }

  Future<TrainDetail> _resolveStationNames(TrainDetail dto) async {
    final codes = <String>{
      dto.departureStationCode,
      dto.arrivalStationCode,
      ...dto.stops.map((s) => s.stationCode),
    }.where((c) => c.isNotEmpty).toList();

    if (codes.isEmpty) return dto;

    try {
      final snap = await FirebaseFirestore.instance
          .collection('stations')
          .where(FieldPath.documentId, whereIn: codes)
          .get();

      final nameMap = <String, String>{};
      for (final doc in snap.docs) {
        nameMap[doc.id] = (doc.data()['name'] as String?) ?? doc.id;
      }

      final resolvedStops = <RouteStop>[];
      for (int i = 0; i < dto.stops.length; i++) {
        final s = dto.stops[i];
        resolvedStops.add(
          RouteStopDTO(
            stationCode: s.stationCode,
            stationName: nameMap[s.stationCode] ?? s.stationCode,
            arrivalTime: s.arrivalTime,
            departureTime: s.departureTime,
            isDeparture: i == 0,
            isDestination: i == dto.stops.length - 1,
            isPassed: false,
          ),
        );
      }

      return TrainDetail(
        id: dto.id,
        code: dto.code,
        name: dto.name,
        status: dto.status,
        departureTime: dto.departureTime,
        arrivalTime: dto.arrivalTime,
        duration: dto.duration,
        departureStationCode: dto.departureStationCode,
        arrivalStationCode: dto.arrivalStationCode,
        departureStationName:
            nameMap[dto.departureStationCode] ?? dto.departureStationCode,
        arrivalStationName:
            nameMap[dto.arrivalStationCode] ?? dto.arrivalStationCode,
        stops: resolvedStops,
        amenities: dto.amenities,
        classOptions: dto.classOptions,
      );
    } catch (e) {
      log('[BookingRepo] _resolveStationNames failed (fallback to codes): $e');
      return dto;
    }
  }


  @override
  Future<List<Seat>> getSeatsForCoach(
    String trainId,
    String coachNumber,
    String classId, {
    double classPrice = 0.0,
  }) async {
    try {
      final allSeats = await firestoreDataSource.fetchSeatsForTrip(
        trainId,
        classId,
        classPrice: classPrice,
        coachNumber: coachNumber,
      );

      final filtered = coachNumber.isEmpty
          ? allSeats
          : allSeats.where((s) => s.coachNumber == coachNumber).toList();
      log('filtered=$filtered');
      return filtered;
    } on FirebaseException catch (e) {
      final failure = mapFirebaseException(e);
      log('[BookingRepo] getSeatsForCoach error: ${failure.message}');
      throw Exception(failure.message);
    } catch (e) {
      log('[BookingRepo] getSeatsForCoach unknown error: $e');
      rethrow;
    }
  }


  @override
  Future<BookingSummary> calculateBookingSummary({
    required TravelClass selectedClass,
    required List<Seat> selectedSeats,
    required int passengerCount,
  }) async {
    final subtotal = selectedClass.price * passengerCount;
    const seatReservationFee = 20.0;
    const serviceFee = 12.0;
    final taxableAmount = subtotal + seatReservationFee + serviceFee;
    final vat = taxableAmount * 0.15;
    final grandTotal = taxableAmount + vat;

    return BookingSummary(
      subtotal: subtotal,
      seatReservationFee: seatReservationFee,
      serviceFee: serviceFee,
      vat: double.parse(vat.toStringAsFixed(2)),
      grandTotal: double.parse(grandTotal.toStringAsFixed(2)),
    );
  }

  @override
  Future<bool> validatePassengers({
    required List<Passenger> passengers,
    required String email,
    required String phone,
  }) async {
    if (email.isEmpty || !email.contains('@')) return false;
    if (phone.isEmpty || phone.length < 7) return false;
    for (final p in passengers) {
      if (p.fullName.trim().isEmpty) return false;
      if (p.nationalIdOrPassport.trim().isEmpty) return false;
    }
    final models = passengers
        .map(
          (p) => PassengerModel(
            passengerId: p.passengerId,
            index: p.index,
            fullName: p.fullName,
            nationalIdOrPassport: p.nationalIdOrPassport,
            assignedSeat: p.assignedSeat,
          ),
        )
        .toList();

    return true;
  }

  @override
  Future<bool> processPayment({
    required BookingSummary summary,
    required PaymentMethod paymentMethod,
    String? cvv,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  @override
  Future<String> bookingTicket({
    required TrainDetail train,
    required TravelClass selectedClass,
    required int passangers,
    required String selectedCoachNumber,
    required BookingSummary booking,
  }) async {
    try {
      final userId = CacheHelper.getData(ApiKeys.id);

      if (userId == null) {
        throw Exception('User is not logged in');
      }

      final bookingId = await firestoreDataSource.bookingTicket(
        booking: booking,
        userId: userId.toString(),
        train: train,
        selectedClass: selectedClass,
        passangers: passangers,
        selectedCoachNumber: selectedCoachNumber,
      );

      log('[BookingRepo] Ticket booked successfully');
      return bookingId;
    } on FirebaseException catch (e) {
      final failure = mapFirebaseException(e);
      log('[BookingRepo] bookingTicket error: ${failure.message}');
      throw Exception(failure.message);
    } catch (e) {
      log('[BookingRepo] bookingTicket unknown error: $e');
      rethrow;
    }
  }
}
