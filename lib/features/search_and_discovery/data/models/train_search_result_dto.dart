import 'package:ride_way_app/features/search_and_discovery/domain/entities/train_search_result.dart';

class TrainSearchResultDTO extends TrainSearchResult {
  const TrainSearchResultDTO({
    required super.id,
    required super.trainCode,
    required super.trainName,
    required super.departureTime,
    required super.arrivalTime,
    required super.duration,
    required super.originCode,
    required super.destinationCode,
    required super.originName,
    required super.destinationName,
    required super.startingPrice,
    required super.availableSeatsCount,
    required super.status,
    required super.amenities,
  });

  factory TrainSearchResultDTO.fromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    return TrainSearchResultDTO(
      id: documentId,
      trainCode: data['trainCode'] ?? '',
      trainName: data['trainName'] ?? '',
      departureTime: data['departureTime'] ?? '',
      arrivalTime: data['arrivalTime'] ?? '',
      duration: data['duration'] ?? '',
      originCode: data['originCode'] ?? '',
      destinationCode: data['destinationCode'] ?? '',
      originName: data['originName'] ?? '',
      destinationName: data['destinationName'] ?? '',
      startingPrice: (data['startingPrice'] ?? 0).toDouble(),
      availableSeatsCount: data['availableSeatsCount'] ?? 0,
      status: data['status'] ?? 'On time',
      amenities: List<String>.from(data['amenities'] ?? []),
    );
  }
}