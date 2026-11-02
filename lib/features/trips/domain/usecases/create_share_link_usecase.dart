import '../repositories/trips_repository.dart';

class CreateShareLinkUseCase {
  final TripsRepository repository;
  CreateShareLinkUseCase(this.repository);

  Future<String> execute(String bookingId) =>
      repository.createShareLink(bookingId);
}
