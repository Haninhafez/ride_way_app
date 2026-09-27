import '../entities/passenger.dart';
import '../repositories/booking_repository.dart';

class ValidatePassengersUseCase {
  final BookingRepository repository;

  ValidatePassengersUseCase(this.repository);

  Future<bool> execute({
    required List<Passenger> passengers,
    required String email,
    required String phone,
  }) {
    return repository.validatePassengers(
      passengers: passengers,
      email: email,
      phone: phone,
    );
  }
}
