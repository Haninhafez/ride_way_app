import 'package:ride_way_app/features/booking/domain/entities/payment_method.dart';

import '../entities/payment_session.dart';
import '../repositories/payment_repository.dart';

class StartPayment {
  final PaymentRepository _repository;
  const StartPayment(this._repository);

  Future<PaymentSession> call({
    required String userId,
    required int amountEgp,
    required PaymentMethodType method,
    String? walletPhone,
  }) {
    return _repository.startPayment(
      userId: userId,
      amountEgp: amountEgp,
      method: method,
      walletPhone: walletPhone,
    );
  }
}
