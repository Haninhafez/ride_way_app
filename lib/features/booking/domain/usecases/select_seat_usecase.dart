import '../entities/seat.dart';
import '../repositories/booking_repository.dart';

class SelectSeatUseCase {
  final BookingRepository repository;

  SelectSeatUseCase(this.repository);

  Future<List<Seat>> getSeatsForCoach(String trainId, String coachNumber) {
    return repository.getSeatsForCoach(trainId, coachNumber);
  }
}
