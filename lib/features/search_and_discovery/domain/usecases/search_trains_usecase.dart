import '../entities/search_query.dart';
import '../entities/train_search_result.dart';
import '../repositories/search_repository.dart';

class SearchTrainsUseCase {
  final SearchRepository repository;

  SearchTrainsUseCase(this.repository);

  Future<List<TrainSearchResult>> execute(SearchQuery query) {
    return repository.searchTrains(query);
  }
}
