import '../entities/recent_search.dart';
import '../entities/saved_route.dart';
import '../entities/search_query.dart';
import '../entities/station.dart';
import '../entities/train_search_result.dart';

abstract class SearchRepository {
  Future<List<Station>> getAvailableStations();
  Future<List<TrainSearchResult>> searchTrains(SearchQuery query);
  Future<List<RecentSearch>> getRecentSearches();
  Future<void> clearRecentSearches();
  Future<List<SavedRoute>> getSavedRoutes();
  Future<List<TrainSearchResult>> filterAndSortTrains({
    required List<TrainSearchResult> trains,
    required String sortBy,
    double? maxPrice,
  });
}
