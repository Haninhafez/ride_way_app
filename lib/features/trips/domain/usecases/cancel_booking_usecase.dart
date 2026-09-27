import '../repositories/trips_repository.dart';

class CancelBookingUseCase {
  final TripsRepository repository;

  CancelBookingUseCase(this.repository);

  Future<bool> execute(String bookingIdOrRef) {
    return repository.cancelBooking(bookingIdOrRef);
  }
}
