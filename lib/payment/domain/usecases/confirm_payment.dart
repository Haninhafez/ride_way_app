import '../entities/payment_method.dart';
import '../repositories/payment_repository.dart';

class ConfirmPayment {
  final PaymentRepository _repository;
  const ConfirmPayment(this._repository);

  Future<void> call(String paymentId, PaymentStatus status) {
    return _repository.updateStatus(paymentId, status);
  }
}
