import 'package:ride_way_app/features/booking/domain/entities/route_stop.dart';

class RouteStopDTO extends RouteStop {
  const RouteStopDTO({
    required super.stationName,
    required super.stationCode,
    required super.arrivalTime,
    required super.departureTime,
    super.isDeparture,
    super.isDestination,
    super.isPassed,
  });

  factory RouteStopDTO.fromFirestore(Map<String, dynamic> map) {
    return RouteStopDTO(
      stationName: (map['stationCode'] as String?) ?? '',
      stationCode: (map['stationCode'] as String?) ?? '',
      arrivalTime: (map['arrivalTime'] as String?) ?? '',
      departureTime: (map['departureTime'] as String?) ?? '',
      isDeparture: false,
      isDestination: false,
      isPassed: false,
    );
  }

  @override
  String toString() =>
      'RouteStopDTO(code: $stationCode, '
      'arr: $arrivalTime, dep: $departureTime)';
}
