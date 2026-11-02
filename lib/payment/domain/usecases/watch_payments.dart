import '../entities/payment_record.dart';
import '../repositories/payment_repository.dart';

class WatchPayments {
  final PaymentRepository _repository;
  const WatchPayments(this._repository);

  Stream<List<PaymentRecord>> call(String userId) {
    return _repository.watchPayments(userId);
  }
}
