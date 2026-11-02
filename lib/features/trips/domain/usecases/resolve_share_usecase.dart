import '../entities/ticket_share.dart';
import '../repositories/trips_repository.dart';

class ResolveShareUseCase {
  final TripsRepository repository;
  ResolveShareUseCase(this.repository);

  Future<ResolveShareResult> execute(String token) =>
      repository.resolveShare(token);
}
