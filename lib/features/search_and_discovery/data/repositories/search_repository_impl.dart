import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';
import 'package:ride_way_app/features/search_and_discovery/data/models/station_dto.dart';

import '../../domain/entities/recent_search.dart';
import '../../domain/entities/saved_route.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/train_search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StationDTO>>> getAvailableStations() async {
  
    final stations = await remoteDataSource.fetchStations();
  return stations.fold(
      (failure)=>Left(failure),
      (stations) => Right(stations.map((station) => station).toList()),
    );
  }


  @override
  Future<Either<Failure, List<TrainSearchResult>>> searchTrains(
    SearchQuery query,
  ) {
    return remoteDataSource.fetchTrains(
      originCode: query.originStation.code,
      destinationCode: query.destinationStation.code,
      date: query.departureDate,
    );
  }

  @override
  Future<Either<Failure, List<TrainSearchResult>>> filterAndSortTrains({
    required List<TrainSearchResult> trains,
    required String sortBy,
    double? maxPrice,
  }) async {
    try {
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
      return Right(list);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error'));
    }
  }

  @override
  Future<Either<Failure, void>> clearRecentSearches() {
    // TODO: implement clearRecentSearches
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<RecentSearch>>> getRecentSearches() {
    // TODO: implement getRecentSearches
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SavedRoute>>> getSavedRoutes() {
    // TODO: implement getSavedRoutes
    throw UnimplementedError();
  }
}
