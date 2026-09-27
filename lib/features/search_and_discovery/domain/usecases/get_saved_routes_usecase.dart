import '../entities/saved_route.dart';
import '../repositories/search_repository.dart';

class GetSavedRoutesUseCase {
  final SearchRepository repository;

  GetSavedRoutesUseCase(this.repository);

  Future<List<SavedRoute>> execute() {
    return repository.getSavedRoutes();
  }
}
