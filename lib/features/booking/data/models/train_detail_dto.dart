import 'package:ride_way_app/features/booking/domain/entities/train_detail.dart';
import 'route_stop_dto.dart';
import 'travel_class_dto.dart';

class TrainDetailDTO extends TrainDetail {
  const TrainDetailDTO({
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

  factory TrainDetailDTO.fromFirestore({
    required String tripId,
    required Map<String, dynamic> tripMap,
    Map<String, dynamic>? trainMap,
  }) {
    final durationMinutes = (tripMap['durationMinutes'] as num?)?.toInt() ?? 0;
    final durationLabel = durationMinutes > 0
        ? '${durationMinutes ~/ 60}h ${durationMinutes % 60}m'
        : '';

    final rawStops = tripMap['stops'];
    final stopsList = rawStops is List ? rawStops : <dynamic>[];
    final stops = stopsList
        .whereType<Map<String, dynamic>>()
        .map(RouteStopDTO.fromFirestore)
        .toList()
      ..sort((a, b) {
        final aOrder = stopsList
            .whereType<Map<String, dynamic>>()
            .firstWhere(
              (m) => m['stationCode'] == a.stationCode,
              orElse: () => {'order': 0},
            )['order'] as int? ?? 0;
        final bOrder = stopsList
            .whereType<Map<String, dynamic>>()
            .firstWhere(
              (m) => m['stationCode'] == b.stationCode,
              orElse: () => {'order': 0},
            )['order'] as int? ?? 0;
        return aOrder.compareTo(bOrder);
      });

    final rawClasses = tripMap['classes'];
    final classesList = rawClasses is List ? rawClasses : <dynamic>[];
    final classOptions = classesList
        .whereType<Map<String, dynamic>>()
        .map(TravelClassDTO.fromFirestore)
        .toList();

    final amenities = trainMap != null
        ? List<String>.from((trainMap['amenities'] as List?) ?? [])
        : <String>[];

    final trainCode = (tripMap['trainCode'] as String?) ?? '';
    final trainName = trainMap != null
        ? (trainMap['trainName'] as String?) ?? trainCode
        : trainCode;

    final fromCode = (tripMap['fromStationCode'] as String?) ?? '';
    final toCode = (tripMap['toStationCode'] as String?) ?? '';

    return TrainDetailDTO(
      id: tripId,
      code: trainCode,
      name: trainName,
      status: _mapStatus((tripMap['status'] as String?) ?? 'scheduled'),
      departureTime: (tripMap['departureTime'] as String?) ?? '',
      arrivalTime: (tripMap['arrivalTime'] as String?) ?? '',
      duration: durationLabel,
      departureStationCode: fromCode,
      arrivalStationCode: toCode,
      departureStationName: fromCode,
      arrivalStationName: toCode,
      stops: stops,
      amenities: amenities,
      classOptions: classOptions,
    );
  }

  static String _mapStatus(String raw) {
    switch (raw) {
      case 'delayed':
        return 'Delayed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'On time';
    }
  }

  @override
  String toString() =>
      'TrainDetailDTO(id: $id, code: $code, name: $name, '
      'from: $departureStationCode → $arrivalStationCode, '
      'departure: $departureTime, arrival: $arrivalTime, '
      'duration: $duration, status: $status, '
      'stops: ${stops.length}, classes: ${classOptions.length}, '
      'amenities: $amenities)';
}
