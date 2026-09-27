import 'package:equatable/equatable.dart';

class TrainSearchResult extends Equatable {
  final String id;
  final String trainCode;
  final String trainName;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String originCode;
  final String destinationCode;
  final String originName;
  final String destinationName;
  final double startingPrice;
  final int availableSeatsCount;
  final String status;

  const TrainSearchResult({
    required this.id,
    required this.trainCode,
    required this.trainName,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.originCode,
    required this.destinationCode,
    required this.originName,
    required this.destinationName,
    required this.startingPrice,
    required this.availableSeatsCount,
    this.status = 'On time',
  });

  bool get isLowSeat => availableSeatsCount <= 5;

  @override
  List<Object?> get props => [
        id,
        trainCode,
        trainName,
        departureTime,
        arrivalTime,
        duration,
        originCode,
        destinationCode,
        originName,
        destinationName,
        startingPrice,
        availableSeatsCount,
        status,
      ];
}
