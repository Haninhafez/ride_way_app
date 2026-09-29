import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';

import '../entities/recent_search.dart';
import '../entities/saved_route.dart';
import '../entities/search_query.dart';
import '../entities/station.dart';
import '../entities/train_search_result.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Station>>> getAvailableStations();
  Future<Either<Failure, List<TrainSearchResult>>> searchTrains(SearchQuery query);
  Future<Either<Failure, List<RecentSearch>>> getRecentSearches();
  Future<Either<Failure, void>> clearRecentSearches();
  Future<Either<Failure, List<SavedRoute>>> getSavedRoutes();
  Future<Either<Failure, List<TrainSearchResult>>> filterAndSortTrains({
    required List<TrainSearchResult> trains,
    required String sortBy,
    double? maxPrice,
  });
}
