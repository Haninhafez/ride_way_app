import '../entities/booking.dart';
import '../repositories/trips_repository.dart';

class GetDigitalTicketUseCase {
  final TripsRepository repository;

  GetDigitalTicketUseCase(this.repository);

  Future<Booking?> execute(String bookingIdOrRef) {
    return repository.getDigitalTicket(bookingIdOrRef);
  }
}
