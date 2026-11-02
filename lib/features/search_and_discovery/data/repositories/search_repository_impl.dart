import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';
import 'package:ride_way_app/core/error/firebase_exception_mapper.dart';

import '../../domain/entities/recent_search.dart';
import '../../domain/entities/saved_route.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/train_search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  const SearchRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, List<Station>>> getAvailableStations() async {
    try {
      final dtos = await remoteDataSource.fetchStations();
      return Right(List<Station>.from(dtos));
    } on FirebaseException catch (e) {
      return Left(mapFirebaseException(e));
    } on TypeError catch (e) {
      return Left(ParseFailure('Unexpected data format in stations: $e'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<TrainSearchResult>>> searchTrains(
    SearchQuery query,
  ) async {
    try {
      final dtos = await remoteDataSource.fetchTrains(
        originCode: query.originStation.code,
        destinationCode: query.destinationStation.code,
        date: query.departureDate,
      );
      return Right(List<TrainSearchResult>.from(dtos));
    } on FirebaseException catch (e) {
      return Left(mapFirebaseException(e));
    } on TypeError catch (e) {
      return Left(ParseFailure('Unexpected data format in trips: $e'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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

      switch (sortBy) {
        case 'cheapest':
          list.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
        case 'earliest':
          list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        case 'shortest':
          list.sort((a, b) => a.duration.compareTo(b.duration));
      }

      return Right(list);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<RecentSearch>>> getRecentSearches() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> clearRecentSearches() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<SavedRoute>>> getSavedRoutes() async {
    return const Right([]);
  }
}
