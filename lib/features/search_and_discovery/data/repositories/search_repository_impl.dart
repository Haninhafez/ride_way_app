import '../../domain/entities/recent_search.dart';
import '../../domain/entities/saved_route.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/train_search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_data_source.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Station>> getAvailableStations() {
    return remoteDataSource.fetchStations();
  }

  @override
  Future<List<TrainSearchResult>> searchTrains(SearchQuery query) {
    return remoteDataSource.fetchTrains(
      originCode: query.originStation.stationCode,
      destinationCode: query.destinationStation.stationCode,
      date: query.departureDate,
    );
  }

  @override
  Future<List<RecentSearch>> getRecentSearches() {
    return localDataSource.getRecentSearches();
  }

  @override
  Future<void> clearRecentSearches() {
    return localDataSource.clearRecentSearches();
  }

  @override
  Future<List<SavedRoute>> getSavedRoutes() {
    return localDataSource.getSavedRoutes();
  }

  @override
  Future<List<TrainSearchResult>> filterAndSortTrains({
    required List<TrainSearchResult> trains,
    required String sortBy,
    double? maxPrice,
  }) async {
    List<TrainSearchResult> list = List.from(trains);

    if (maxPrice != null) {
      list = list.where((t) => t.startingPrice <= maxPrice).toList();
    }

    if (sortBy == 'cheapest') {
      list.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
    } else if (sortBy == 'earliest') {
      list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    } else if (sortBy == 'shortest') {
      list.sort((a, b) => a.duration.compareTo(b.duration));
    }

    return list;
  }
}
