import 'package:ride_way_app/features/booking/domain/entities/payment_method.dart';

import '../entities/payment_method.dart';
import '../entities/payment_record.dart';
import '../entities/payment_session.dart';

abstract class PaymentRepository {
  Future<PaymentSession> startPayment({
    required String userId,
    required int amountEgp,
    required PaymentMethodType method,
    String? walletPhone,
  });

  Future<void> updateStatus(String paymentId, PaymentStatus status);

  Stream<List<PaymentRecord>> watchPayments(String userId);
}
