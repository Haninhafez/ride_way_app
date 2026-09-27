import '../../domain/entities/train_search_result.dart';

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
    super.status,
  });

  factory TrainSearchResultDTO.fromJson(Map<String, dynamic> json) {
    return TrainSearchResultDTO(
      id: json['id'] ?? '',
      trainCode: json['trainCode'] ?? '',
      trainName: json['trainName'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      duration: json['duration'] ?? '',
      originCode: json['originCode'] ?? '',
      destinationCode: json['destinationCode'] ?? '',
      originName: json['originName'] ?? '',
      destinationName: json['destinationName'] ?? '',
      startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0.0,
      availableSeatsCount: json['availableSeatsCount'] ?? 0,
      status: json['status'] ?? 'On time',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trainCode': trainCode,
      'trainName': trainName,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'originCode': originCode,
      'destinationCode': destinationCode,
      'originName': originName,
      'destinationName': destinationName,
      'startingPrice': startingPrice,
      'availableSeatsCount': availableSeatsCount,
      'status': status,
    };
  }
}
