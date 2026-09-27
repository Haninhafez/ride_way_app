import '../../domain/entities/payment_method.dart';

class PaymentMethodModel extends PaymentMethod {
  const PaymentMethodModel({
    required super.type,
    super.cardLast4,
    super.expiryDate,
    required super.label,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      type: PaymentMethodType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PaymentMethodType.creditCard,
      ),
      cardLast4: json['cardLast4'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'cardLast4': cardLast4,
      'expiryDate': expiryDate,
      'label': label,
    };
  }
}
