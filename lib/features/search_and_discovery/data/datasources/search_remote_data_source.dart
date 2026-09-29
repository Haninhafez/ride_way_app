import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';

import '../models/station_dto.dart';
import '../models/train_search_result_dto.dart';

abstract class SearchRemoteDataSource {
  Future<Either<Failure, List<StationDTO>>> fetchStations();
  Future<Either<Failure, List<TrainSearchResultDTO>>> fetchTrains({
    required String originCode,
    required String destinationCode,
    required DateTime date,
  });
 
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final FirebaseFirestore firestore;

SearchRemoteDataSourceImpl({
  required this.firestore,
});

@override
Future<Either<Failure, List<StationDTO>>> fetchStations() async {
  try {
    final snapshot = await firestore
        .collection('stations')
        .get();

    final stations = snapshot.docs
        .map(
          (doc) => StationDTO.fromFirestore(
            doc.data(),
          ),
        )
        .toList();

    return Right(stations);
  } on FirebaseException catch (e) {
    return Left(
      ServerFailure(e.message ?? 'Firebase error'),
    );
  } catch (e) {
    return Left(
      ServerFailure(e.toString()),
    );
  }
}

  @override
  Future<Either<Failure, List<TrainSearchResultDTO>>> fetchTrains({
  required String originCode,
  required String destinationCode,
  required DateTime date,
}) async {
  try {
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final snapshot = await firestore
        .collection('trains')
        .where('originCode', isEqualTo: originCode)
        .where('destinationCode', isEqualTo: destinationCode)
        .where('departureDate', isEqualTo: dateString)
        .get();

    final trains = snapshot.docs
        .map(
          (doc) => TrainSearchResultDTO.fromFirestore(
            doc.id,
            doc.data(),
          ),
        )
        .toList();

    return Right(trains);
  } on FirebaseException catch (e) {
    return Left(
      ServerFailure(e.message ?? 'Firebase error'),
    );
  } catch (e) {
    return Left(
      ServerFailure(e.toString()),
    );
  }
}
}