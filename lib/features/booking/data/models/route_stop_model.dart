import '../../domain/entities/route_stop.dart';

class RouteStopModel extends RouteStop {
  const RouteStopModel({
    required super.stationName,
    required super.stationCode,
    required super.arrivalTime,
    required super.departureTime,
    super.isDeparture,
    super.isDestination,
    super.isPassed,
  });

  factory RouteStopModel.fromJson(Map<String, dynamic> json) {
    return RouteStopModel(
      stationName: json['stationName'] ?? '',
      stationCode: json['stationCode'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      departureTime: json['departureTime'] ?? '',
      isDeparture: json['isDeparture'] ?? false,
      isDestination: json['isDestination'] ?? false,
      isPassed: json['isPassed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationName': stationName,
      'stationCode': stationCode,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
      'isDeparture': isDeparture,
      'isDestination': isDestination,
      'isPassed': isPassed,
    };
  }
}
