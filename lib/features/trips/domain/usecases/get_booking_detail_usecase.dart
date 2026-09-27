import '../entities/booking.dart';
import '../repositories/trips_repository.dart';

class GetBookingDetailUseCase {
  final TripsRepository repository;

  GetBookingDetailUseCase(this.repository);

  Future<Booking?> execute(String bookingIdOrRef) {
    return repository.getBookingDetail(bookingIdOrRef);
  }
}
