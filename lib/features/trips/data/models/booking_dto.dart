
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking.dart';
import 'passenger_seat_dto.dart';
import 'payment_summary_dto.dart';

class BookingDTO extends Booking {
  const BookingDTO({
    required super.id,
    required super.bookingRef,
    required super.status,
    required super.trainCode,
    required super.trainName,
    required super.origin,
    required super.destination,
    required super.originName,
    required super.destinationName,
    required super.travelDate,
    required super.departureTime,
    required super.arrivalTime,
    required super.duration,
    required super.platform,
    required super.coach,
    required super.travelClass,
    required super.passengers,
    required super.paymentSummary,
    required super.qrCodeData,
  });

  factory BookingDTO.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    final passengersJson = json['passengers'] as List<dynamic>? ?? [];

    final paymentJson =
        json['paymentSummary'] as Map<String, dynamic>?;

    return BookingDTO(
      id: json['id']?.toString() ?? '',
      bookingRef: json['bookingRef']?.toString() ?? '',
      status: BookingStatusType.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatusType.upcoming,
      ),
      trainCode: json['trainCode']?.toString() ?? '',
      trainName: json['trainName']?.toString() ?? '',
      origin: json['origin']?.toString() ?? '',
      destination: json['destination']?.toString() ?? '',
      originName: json['originName']?.toString() ?? '',
      destinationName: json['destinationName']?.toString() ?? '',
      travelDate: parseDate(json['travelDate']),
      departureTime: json['departureTime']?.toString() ?? '',
      arrivalTime: json['arrivalTime']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      platform: json['platform']?.toString() ?? '',
      coach: json['coach']?.toString() ?? '',
      travelClass: json['travelClass']?.toString() ?? 'Business',
      passengers: passengersJson
          .whereType<Map<String, dynamic>>()
          .map((e) => PassengerSeatDTO.fromJson(e))
          .toList(),
      paymentSummary: paymentJson != null
          ? PaymentSummaryDTO.fromJson(paymentJson)
          : const PaymentSummaryDTO(
              paymentMethod: '',
              fareSubtotal: 0,
              feesAndVat: 0,
              totalPaid: 0,
            ),
      qrCodeData: json['qrCodeData']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingRef': bookingRef,
      'status': status.name,
      'trainCode': trainCode,
      'trainName': trainName,
      'origin': origin,
      'destination': destination,
      'originName': originName,
      'destinationName': destinationName,
      'travelDate': Timestamp.fromDate(travelDate),
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'platform': platform,
      'coach': coach,
      'travelClass': travelClass,
      'passengers': passengers
          .map((e) => (e as PassengerSeatDTO).toJson())
          .toList(),
      'paymentSummary': (paymentSummary as PaymentSummaryDTO).toJson(),
      'qrCodeData': qrCodeData,
    };
  }
}
