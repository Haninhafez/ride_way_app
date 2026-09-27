import '../entities/train_search_result.dart';
import '../repositories/search_repository.dart';

class FilterAndSortTrainsUseCase {
  final SearchRepository repository;

  FilterAndSortTrainsUseCase(this.repository);

  Future<List<TrainSearchResult>> execute({
    required List<TrainSearchResult> trains,
    required String sortBy,
    double? maxPrice,
  }) {
    return repository.filterAndSortTrains(
      trains: trains,
      sortBy: sortBy,
      maxPrice: maxPrice,
    );
  }
}
