import '../entities/booking_summary.dart';
import '../entities/payment_method.dart';
import '../repositories/booking_repository.dart';

class ProcessPaymentUseCase {
  final BookingRepository repository;

  ProcessPaymentUseCase(this.repository);

  Future<bool> execute({
    required BookingSummary summary,
    required PaymentMethod paymentMethod,
    String? cvv,
  }) {
    return repository.processPayment(
      summary: summary,
      paymentMethod: paymentMethod,
      cvv: cvv,
    );
  }
}
