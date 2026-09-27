import '../../domain/entities/train_detail.dart';
import 'route_stop_model.dart';
import 'travel_class_model.dart';

class TrainDetailModel extends TrainDetail {
  const TrainDetailModel({
    required super.id,
    required super.code,
    required super.name,
    required super.status,
    required super.departureTime,
    required super.arrivalTime,
    required super.duration,
    required super.departureStationCode,
    required super.arrivalStationCode,
    required super.departureStationName,
    required super.arrivalStationName,
    required super.stops,
    required super.amenities,
    required super.classOptions,
  });

  factory TrainDetailModel.fromJson(Map<String, dynamic> json) {
    return TrainDetailModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'On time',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      duration: json['duration'] ?? '',
      departureStationCode: json['departureStationCode'] ?? '',
      arrivalStationCode: json['arrivalStationCode'] ?? '',
      departureStationName: json['departureStationName'] ?? '',
      arrivalStationName: json['arrivalStationName'] ?? '',
      stops: (json['stops'] as List<dynamic>?)
              ?.map((e) => RouteStopModel.fromJson(e))
              .toList() ??
          [],
      amenities: List<String>.from(json['amenities'] ?? []),
      classOptions: (json['classOptions'] as List<dynamic>?)
              ?.map((e) => TravelClassModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'status': status,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'departureStationCode': departureStationCode,
      'arrivalStationCode': arrivalStationCode,
      'departureStationName': departureStationName,
      'arrivalStationName': arrivalStationName,
      'stops': stops.map((e) => (e as RouteStopModel).toJson()).toList(),
      'amenities': amenities,
      'classOptions': classOptions.map((e) => (e as TravelClassModel).toJson()).toList(),
    };
  }
}
