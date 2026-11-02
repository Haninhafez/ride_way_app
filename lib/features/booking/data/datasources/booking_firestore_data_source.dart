import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_way_app/core/error/exceptions.dart';
import 'package:ride_way_app/features/booking/domain/entities/booking_summary.dart';
import 'package:ride_way_app/features/booking/domain/entities/train_detail.dart';
import 'package:ride_way_app/features/booking/domain/entities/travel_class.dart';

import '../models/seat_dto.dart';
import '../models/train_detail_dto.dart';

abstract class BookingFirestoreDataSource {
  Future<TrainDetailDTO> fetchTripWithTrainDetails(String tripId);

  Future<List<SeatDTO>> fetchSeatsForTrip(
    String tripId,
    String classId, {
    double classPrice = 0.0,
    String coachNumber = '',
  });

  Future<String> bookingTicket({
    required String userId,
    required TrainDetail train,
    required TravelClass selectedClass,
    required int passangers,
    required String selectedCoachNumber,
    required BookingSummary booking,
  });
}

class BookingFirestoreDataSourceImpl implements BookingFirestoreDataSource {
  final FirebaseFirestore firestore;

  const BookingFirestoreDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _seats(String tripId) =>
      firestore.collection('trips').doc(tripId).collection('seats');

  @override
  Future<TrainDetailDTO> fetchTripWithTrainDetails(String tripId) async {
    final tripSnap = await firestore.collection('trips').doc(tripId).get();
    final trip = tripSnap.data();
    if (trip == null) {
      throw NotFoundException('This trip is no longer available.');
    }

    final trainSnap = await firestore
        .collection('trains')
        .doc(trip['trainCode'] as String)
        .get();

    log('[BookingFirestoreDS] fetchTripWithTrainDetails\n $tripSnap');

    return TrainDetailDTO.fromFirestore(
      tripId: tripId,
      tripMap: trip,
      trainMap: trainSnap.data(),
    );
  }


  @override
  Future<List<SeatDTO>> fetchSeatsForTrip(
    String tripId,
    String classId, {
    double classPrice = 0.0,
    String coachNumber = '',
  }) async {
    final snap = await _seats(tripId).get();

    final seats = snap.docs.map((d) {
      return SeatDTO.fromFirestore(
        d.id,
        d.data(),
        classPrice: classPrice,
        coachNumber: coachNumber,
      );
    }).toList();

    seats.sort((a, b) => a.seatNumber.compareTo(b.seatNumber));
    log('[BookingFirestoreDS] fetchSeatsForTrip($tripId) → seats=$seats');

    return seats;
  }

  @override
  Future<String> bookingTicket({
    required String userId,
    required TrainDetail train,
    required TravelClass selectedClass,
    required int passangers,
    required String selectedCoachNumber,
    required BookingSummary booking,
  }) async {
    final bookingDoc = firestore.collection('bookings').doc();

    await bookingDoc.set({
      'userId': userId,
      'id': bookingDoc
          .id, 
      'bookingRef':
          'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'status': 'confirmed',

      'trainCode': train.code,
      'trainName': train.name,
      'origin': train.departureStationCode,
      'destination': train.arrivalStationCode,
      'originName': train.departureStationName,
      'destinationName': train.arrivalStationName,
      'travelDate': Timestamp.fromDate(
        DateTime.now(),
      ), 
      'departureTime': train.departureTime,
      'arrivalTime': train.arrivalTime,
      'duration': train.duration,
      'platform': '1', 
      'coach': selectedCoachNumber,
      'travelClass': selectedClass.title,
      'passengersCount': passangers,

      'passengers': List.generate(
        passangers,
        (index) => {
          'passengerName': 'Passenger ${index + 1}',
          'passengerType': 'Adult',
          'seatNumber': '$selectedCoachNumber-${index + 1}',
        },
      ),

      'paymentSummary': {
        'paymentMethod': 'Credit Card',
        'fareSubtotal': booking.subtotal,
        'seatReservationFee': booking.seatReservationFee,
        'serviceFee': booking.serviceFee,
        'vat': booking.vat,
        'totalPaid': booking.grandTotal,
      },

      'qrCodeData': 'QR-$userId-${DateTime.now().millisecondsSinceEpoch}',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return bookingDoc.id;
  }

  static String _defaultCoach(String classId) {
    switch (classId) {
      case 'first':
        return '1';
      case 'business':
        return '3';
      default:
        return '6';
    }
  }
}
