import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/entities/station.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/repositories/search_repository.dart';

class GetStationUseCase {
  final SearchRepository repository;

  GetStationUseCase({required this.repository});
  Future<Either<Failure, List<Station>>> execute() {
    return repository.getAvailableStations();
  }
}
