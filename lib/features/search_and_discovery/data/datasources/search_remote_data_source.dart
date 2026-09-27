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
  @override
  Future<List<StationDTO>> fetchStations() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const [
      StationDTO(stationCode: 'DMM', name: 'Dammam', city: 'Dammam'),
      StationDTO(stationCode: 'JED', name: 'Jeddah', city: 'Jeddah'),
      StationDTO(stationCode: 'RUH', name: 'Riyadh', city: 'Riyadh'),
      StationDTO(stationCode: 'HFR', name: 'Hafar Al-Batin', city: 'Hafar Al-Batin'),
      StationDTO(stationCode: 'KAEC', name: 'KAEC', city: 'King Abdullah Economic City'),
    ];
  }

  @override
  Future<List<TrainSearchResultDTO>> fetchTrains({
    required String originCode,
    required String destinationCode,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      TrainSearchResultDTO(
        id: 't1',
        trainCode: 'SE-200',
        trainName: 'Saudi Express',
        departureTime: '06:15',
        arrivalTime: '14:25',
        duration: '8h 10m',
        originCode: originCode.isNotEmpty ? originCode : 'DMM',
        destinationCode: destinationCode.isNotEmpty ? destinationCode : 'JED',
        originName: 'Dammam Central',
        destinationName: 'Jeddah Sulaimaniyah',
        startingPrice: 145.0,
        availableSeatsCount: 3, // Low-seat warning indicator
        status: 'On time',
      ),
      TrainSearchResultDTO(
        id: 't2',
        trainCode: 'SE-204',
        trainName: 'Saudi Express',
        departureTime: '09:30',
        arrivalTime: '17:45',
        duration: '8h 15m',
        originCode: originCode.isNotEmpty ? originCode : 'DMM',
        destinationCode: destinationCode.isNotEmpty ? destinationCode : 'JED',
        originName: 'Dammam Central',
        destinationName: 'Jeddah Sulaimaniyah',
        startingPrice: 265.0,
        availableSeatsCount: 64, // Standard availability
        status: 'On time',
      ),
      TrainSearchResultDTO(
        id: 't3',
        trainCode: 'HD-110',
        trainName: 'Haramain Highspeed',
        departureTime: '13:00',
        arrivalTime: '20:15',
        duration: '7h 15m',
        originCode: originCode.isNotEmpty ? originCode : 'DMM',
        destinationCode: destinationCode.isNotEmpty ? destinationCode : 'JED',
        originName: 'Dammam Central',
        destinationName: 'Jeddah Sulaimaniyah',
        startingPrice: 195.0,
        availableSeatsCount: 4, // Low-seat warning indicator
        status: 'On time',
      ),
      TrainSearchResultDTO(
        id: 't4',
        trainCode: 'SE-310',
        trainName: 'Night Express',
        departureTime: '22:00',
        arrivalTime: '06:10',
        duration: '8h 10m',
        originCode: originCode.isNotEmpty ? originCode : 'DMM',
        destinationCode: destinationCode.isNotEmpty ? destinationCode : 'JED',
        originName: 'Dammam Central',
        destinationName: 'Jeddah Sulaimaniyah',
        startingPrice: 130.0,
        availableSeatsCount: 28,
        status: 'On time',
      ),
    ];
  }
}
