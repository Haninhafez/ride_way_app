import '../../domain/entities/payment_summary.dart';

class PaymentSummaryDTO extends PaymentSummary {
  const PaymentSummaryDTO({
    required super.paymentMethod,
    required super.fareSubtotal,
    required super.feesAndVat,
    required super.totalPaid,
  });

  factory PaymentSummaryDTO.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryDTO(
      paymentMethod: json['paymentMethod'] ?? '',
      fareSubtotal: (json['fareSubtotal'] as num?)?.toDouble() ?? 0.0,
      feesAndVat: (json['feesAndVat'] as num?)?.toDouble() ?? 0.0,
      totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'fareSubtotal': fareSubtotal,
      'feesAndVat': feesAndVat,
      'totalPaid': totalPaid,
    };
  }
}
