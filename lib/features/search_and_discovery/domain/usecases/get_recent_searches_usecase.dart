import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';

import '../entities/recent_search.dart';
import '../repositories/search_repository.dart';

class GetRecentSearchesUseCase {
  final SearchRepository repository;

  GetRecentSearchesUseCase(this.repository);

  Future<Either<Failure,List<RecentSearch>>> execute() {
    return repository.getRecentSearches();
  }

  Future<void> clearAll() {
    return repository.clearRecentSearches();
  }
}
