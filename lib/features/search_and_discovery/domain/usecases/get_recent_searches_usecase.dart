import '../entities/recent_search.dart';
import '../repositories/search_repository.dart';

class GetRecentSearchesUseCase {
  final SearchRepository repository;

  GetRecentSearchesUseCase(this.repository);

  Future<List<RecentSearch>> execute() {
    return repository.getRecentSearches();
  }

  Future<void> clearAll() {
    return repository.clearRecentSearches();
  }
}
