import 'package:equatable/equatable.dart';
import 'passenger_seat.dart';
import 'payment_summary.dart';

enum BookingStatusType { upcoming, completed, cancelled }

class Booking extends Equatable {
  final String id;
  final String bookingRef;
  final BookingStatusType status;
  final String trainCode;
  final String trainName;
  final String origin;
  final String destination;
  final String originName;
  final String destinationName;
  final DateTime travelDate;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String platform;
  final String coach;
  final String travelClass;
  final List<PassengerSeat> passengers;
  final PaymentSummary paymentSummary;
  final String qrCodeData;

  const Booking({
    required this.id,
    required this.bookingRef,
    required this.status,
    required this.trainCode,
    required this.trainName,
    required this.origin,
    required this.destination,
    required this.originName,
    required this.destinationName,
    required this.travelDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.platform,
    required this.coach,
    required this.travelClass,
    required this.passengers,
    required this.paymentSummary,
    required this.qrCodeData,
  });

  Booking copyWith({
    String? id,
    String? bookingRef,
    BookingStatusType? status,
    String? trainCode,
    String? trainName,
    String? origin,
    String? destination,
    String? originName,
    String? destinationName,
    DateTime? travelDate,
    String? departureTime,
    String? arrivalTime,
    String? duration,
    String? platform,
    String? coach,
    String? travelClass,
    List<PassengerSeat>? passengers,
    PaymentSummary? paymentSummary,
    String? qrCodeData,
  }) {
    return Booking(
      id: id ?? this.id,
      bookingRef: bookingRef ?? this.bookingRef,
      status: status ?? this.status,
      trainCode: trainCode ?? this.trainCode,
      trainName: trainName ?? this.trainName,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      originName: originName ?? this.originName,
      destinationName: destinationName ?? this.destinationName,
      travelDate: travelDate ?? this.travelDate,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      duration: duration ?? this.duration,
      platform: platform ?? this.platform,
      coach: coach ?? this.coach,
      travelClass: travelClass ?? this.travelClass,
      passengers: passengers ?? this.passengers,
      paymentSummary: paymentSummary ?? this.paymentSummary,
      qrCodeData: qrCodeData ?? this.qrCodeData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bookingRef,
        status,
        trainCode,
        trainName,
        origin,
        destination,
        originName,
        destinationName,
        travelDate,
        departureTime,
        arrivalTime,
        duration,
        platform,
        coach,
        travelClass,
        passengers,
        paymentSummary,
        qrCodeData,
      ];
}
