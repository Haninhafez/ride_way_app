import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';

import '../entities/saved_route.dart';
import '../repositories/search_repository.dart';

class GetSavedRoutesUseCase {
  final SearchRepository repository;

  GetSavedRoutesUseCase(this.repository);

  Future<Either<Failure, List<SavedRoute>>> execute() {
    return repository.getSavedRoutes();
  }
}
