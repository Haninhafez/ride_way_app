import 'package:equatable/equatable.dart';

class PaymentSummary extends Equatable {
  final String paymentMethod;
  final double fareSubtotal;
  final double feesAndVat;
  final double totalPaid;

  const PaymentSummary({
    required this.paymentMethod,
    required this.fareSubtotal,
    required this.feesAndVat,
    required this.totalPaid,
  });

  @override
  List<Object?> get props => [
        paymentMethod,
        fareSubtotal,
        feesAndVat,
        totalPaid,
      ];
}
