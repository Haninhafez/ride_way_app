import 'package:equatable/equatable.dart';
import 'route_stop.dart';
import 'travel_class.dart';

class TrainDetail extends Equatable {
  final String id;
  final String code;
  final String name;
  final String status;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String departureStationCode;
  final String arrivalStationCode;
  final String departureStationName;
  final String arrivalStationName;
  final List<RouteStop> stops;
  final List<String> amenities;
  final List<TravelClass> classOptions;

  const TrainDetail({
    required this.id,
    required this.code,
    required this.name,
    required this.status,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.departureStationCode,
    required this.arrivalStationCode,
    required this.departureStationName,
    required this.arrivalStationName,
    required this.stops,
    required this.amenities,
    required this.classOptions,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        status,
        departureTime,
        arrivalTime,
        duration,
        departureStationCode,
        arrivalStationCode,
        departureStationName,
        arrivalStationName,
        stops,
        amenities,
        classOptions,
      ];
}
