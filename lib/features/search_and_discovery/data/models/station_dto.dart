import '../../domain/entities/station.dart';

class StationDTO extends Station {
  const StationDTO({
    required super.stationCode,
    required super.name,
    required super.city,
  });

  factory StationDTO.fromJson(Map<String, dynamic> json) {
    return StationDTO(
      stationCode: json['stationCode'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationCode': stationCode,
      'name': name,
      'city': city,
    };
  }
}
