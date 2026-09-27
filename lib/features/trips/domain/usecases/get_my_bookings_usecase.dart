import '../entities/booking.dart';
import '../repositories/trips_repository.dart';

class GetMyBookingsUseCase {
  final TripsRepository repository;

  GetMyBookingsUseCase(this.repository);

  Future<List<Booking>> execute() {
    return repository.getMyBookings();
  }
}
