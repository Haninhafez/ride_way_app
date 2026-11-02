import '../repositories/trips_repository.dart';

class RevokeShareLinkUseCase {
  final TripsRepository repository;
  RevokeShareLinkUseCase(this.repository);

  Future<void> execute(String bookingId) =>
      repository.revokeShareLink(bookingId);
}
