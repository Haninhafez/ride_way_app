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
    return BookingDTO(
      id: json['id'] ?? '',
      bookingRef: json['bookingRef'] ?? '',
      status: BookingStatusType.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatusType.upcoming,
      ),
      trainCode: json['trainCode'] ?? '',
      trainName: json['trainName'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      originName: json['originName'] ?? '',
      destinationName: json['destinationName'] ?? '',
      travelDate: DateTime.tryParse(json['travelDate'] ?? '') ?? DateTime.now(),
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      duration: json['duration'] ?? '',
      platform: json['platform'] ?? '',
      coach: json['coach'] ?? '',
      travelClass: json['travelClass'] ?? 'Business',
      passengers: (json['passengers'] as List<dynamic>?)
              ?.map((e) => PassengerSeatDTO.fromJson(e))
              .toList() ??
          [],
      paymentSummary: json['paymentSummary'] != null
          ? PaymentSummaryDTO.fromJson(json['paymentSummary'])
          : const PaymentSummaryDTO(
              paymentMethod: 'Mada •••• 4417',
              fareSubtotal: 530.0,
              feesAndVat: 93.0,
              totalPaid: 623.0,
            ),
      qrCodeData: json['qrCodeData'] ?? '',
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
      'travelDate': travelDate.toIso8601String(),
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'platform': platform,
      'coach': coach,
      'travelClass': travelClass,
      'passengers': passengers.map((e) => (e as PassengerSeatDTO).toJson()).toList(),
      'paymentSummary': (paymentSummary as PaymentSummaryDTO).toJson(),
      'qrCodeData': qrCodeData,
    };
  }
}
