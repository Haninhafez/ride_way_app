import 'package:equatable/equatable.dart';

class RouteStop extends Equatable {
  final String stationName;
  final String stationCode;
  final String arrivalTime;
  final String departureTime;
  final bool isDeparture;
  final bool isDestination;
  final bool isPassed;

  const RouteStop({
    required this.stationName,
    required this.stationCode,
    required this.arrivalTime,
    required this.departureTime,
    this.isDeparture = false,
    this.isDestination = false,
    this.isPassed = false,
  });

  @override
  List<Object?> get props => [
        stationName,
        stationCode,
        arrivalTime,
        departureTime,
        isDeparture,
        isDestination,
        isPassed,
      ];
}
