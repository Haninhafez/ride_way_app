import 'package:equatable/equatable.dart';

class BookingSummary extends Equatable {
  final double subtotal;
  final double seatReservationFee;
  final double serviceFee;
  final double vat;
  final double grandTotal;

  const BookingSummary({
    required this.subtotal,
    required this.seatReservationFee,
    required this.serviceFee,
    required this.vat,
    required this.grandTotal,
  });

  @override
  List<Object?> get props => [
        subtotal,
        seatReservationFee,
        serviceFee,
        vat,
        grandTotal,
      ];
}
