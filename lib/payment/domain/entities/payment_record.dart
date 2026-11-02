import 'package:ride_way_app/features/booking/domain/entities/payment_method.dart';

import 'payment_method.dart';

class PaymentRecord {
  final String id;
  final String userId;
  final int amountEgp;
  final PaymentMethodType method;
  final PaymentStatus status;
  final DateTime createdAt;

  const PaymentRecord({
    required this.id,
    required this.userId,
    required this.amountEgp,
    required this.method,
    required this.status,
    required this.createdAt,
  });
}
