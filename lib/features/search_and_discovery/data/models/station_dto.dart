import '../../domain/entities/station.dart';

class StationDTO extends Station {
  const StationDTO({
    required super.code,
    required super.name,
    required super.city,
    required super.nameAr,
    required super.lat,
    required super.lng,
  });

  factory StationDTO.fromFirestore(Map<String, dynamic> data) {
    return StationDTO(
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      city: data['city'] ?? '',
      nameAr: data['nameAr'] ?? '',
      lat: (data['lat'] ?? 0).toDouble(),
      lng: (data['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'name': name,
      'city': city,
      'nameAr': nameAr,
      'lat': lat,
      'lng': lng,
    };
  }
}