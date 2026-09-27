import 'package:equatable/equatable.dart';

enum PaymentMethodType {
  mada,
  applePay,
  creditCard,
  cashAtStation,
}

class PaymentMethod extends Equatable {
  final PaymentMethodType type;
  final String cardLast4;
  final String expiryDate;
  final String label;

  const PaymentMethod({
    required this.type,
    this.cardLast4 = '',
    this.expiryDate = '',
    required this.label,
  });

  @override
  List<Object?> get props => [type, cardLast4, expiryDate, label];
}
