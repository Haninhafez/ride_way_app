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
    String id,
    Map<String, dynamic> map,
  ) {
    final rawClasses = map['classes'];
    final classes = rawClasses is List ? rawClasses : <dynamic>[];

    double startingPrice = 0.0;
    int totalSeats = 0;

    if (classes.isNotEmpty) {
      final prices = classes
          .whereType<Map<String, dynamic>>()
          .map((c) => (c['price'] as num?)?.toDouble() ?? 0.0)
          .where((p) => p > 0);

      startingPrice = prices.isNotEmpty ? prices.reduce(_min) : 0.0;

      totalSeats = classes
          .whereType<Map<String, dynamic>>()
          .fold(0, (sum, c) => sum + ((c['seatsAvailable'] as num?)?.toInt() ?? 0));
    }

    final durationMinutes = (map['durationMinutes'] as num?)?.toInt() ?? 0;
    final durationLabel = durationMinutes > 0
        ? '${durationMinutes ~/ 60}h ${durationMinutes % 60}m'
        : '';

    final rawStatus = (map['status'] as String?) ?? 'scheduled';
    final displayStatus = _mapStatus(rawStatus);

    return TrainSearchResultDTO(
      id: id,
      trainCode: (map['trainCode'] as String?) ?? '',
      trainName: (map['trainName'] as String?) ?? '',
      departureTime: (map['departureTime'] as String?) ?? '',
      arrivalTime: (map['arrivalTime'] as String?) ?? '',
      duration: durationLabel,
      originCode: (map['fromStationCode'] as String?) ?? '',
      destinationCode: (map['toStationCode'] as String?) ?? '',
      originName: (map['originName'] as String?) ??
          (map['fromStationCode'] as String?) ?? '',
      destinationName: (map['destinationName'] as String?) ??
          (map['toStationCode'] as String?) ?? '',
      startingPrice: startingPrice,
      availableSeatsCount: totalSeats,
      status: displayStatus,
      amenities: List<String>.from((map['amenities'] as List?) ?? []),
    );
  }


  static double _min(double a, double b) => a < b ? a : b;

  static String _mapStatus(String raw) {
    switch (raw) {
      case 'delayed':
        return 'Delayed';
      case 'cancelled':
        return 'Cancelled';
      case 'scheduled':
      default:
        return 'On time';
    }
  }

  @override
  String toString() =>
      'TrainSearchResultDTO(id: $id, trainCode: $trainCode, '
      'from: $originCode → $destinationCode, '
      'departure: $departureTime, arrival: $arrivalTime, '
      'duration: $duration, startingPrice: $startingPrice SAR, '
      'seats: $availableSeatsCount, status: $status)';
}
