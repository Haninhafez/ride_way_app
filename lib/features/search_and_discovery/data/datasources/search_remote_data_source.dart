import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/station_dto.dart';
import '../models/train_search_result_dto.dart';

abstract class SearchRemoteDataSource {
  Future<List<StationDTO>> fetchStations();

  Future<List<TrainSearchResultDTO>> fetchTrains({
    required String originCode,
    required String destinationCode,
    required DateTime date,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final FirebaseFirestore firestore;

  SearchRemoteDataSourceImpl({required this.firestore});


  @override
  Future<List<StationDTO>> fetchStations() async {
    final snapshot = await firestore.collection('stations').get();

    final stations = snapshot.docs.map((doc) {
      return StationDTO.fromFirestore(doc.id, doc.data());
    }).toList();

    log('[SearchRemoteDataSource] fetchStations → ${stations.length} stations');
    return stations;
  }


  @override
  Future<List<TrainSearchResultDTO>> fetchTrains({
    required String originCode,
    required String destinationCode,
    required DateTime date,
  }) async {
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final snapshot = await firestore
        .collection('trips')
        .where('fromStationCode', isEqualTo: originCode)
        .where('toStationCode', isEqualTo: destinationCode)
        .where('date', isEqualTo: dateString)
        .get();

    final trains = snapshot.docs.map((doc) {
      return TrainSearchResultDTO.fromFirestore(doc.id, doc.data());
    }).toList();
    log('trains=$trains');

    log(
      '[SearchRemoteDataSource] fetchTrains($originCode→$destinationCode, $dateString) '
      '→ ${trains.length} trips',
    );

    return trains;
  }
}
