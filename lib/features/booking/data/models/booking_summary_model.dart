import '../../domain/entities/booking_summary.dart';

class BookingSummaryModel extends BookingSummary {
  const BookingSummaryModel({
    required super.subtotal,
    required super.seatReservationFee,
    required super.serviceFee,
    required super.vat,
    required super.grandTotal,
  });

  factory BookingSummaryModel.fromJson(Map<String, dynamic> json) {
    return BookingSummaryModel(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      seatReservationFee: (json['seatReservationFee'] as num?)?.toDouble() ?? 0.0,
      serviceFee: (json['serviceFee'] as num?)?.toDouble() ?? 0.0,
      vat: (json['vat'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'seatReservationFee': seatReservationFee,
      'serviceFee': serviceFee,
      'vat': vat,
      'grandTotal': grandTotal,
    };
  }
}
