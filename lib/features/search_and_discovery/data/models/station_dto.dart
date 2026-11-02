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

  factory StationDTO.fromFirestore(String id, Map<String, dynamic> map) {
    return StationDTO(
      code: (map['code'] as String?)?.trim().isNotEmpty == true
          ? (map['code'] as String).trim()
          : id,
      name: (map['name'] as String?) ?? '',
      nameAr: (map['nameAr'] as String?) ?? '',
      city: (map['city'] as String?) ?? '',
      lat: (map['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {
        'code': code,
        'name': name,
        'nameAr': nameAr,
        'city': city,
        'lat': lat,
        'lng': lng,
      };

  @override
  String toString() =>
      'StationDTO(code: $code, name: $name, nameAr: $nameAr, '
      'city: $city, lat: $lat, lng: $lng)';
}
