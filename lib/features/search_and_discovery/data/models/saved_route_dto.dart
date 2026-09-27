import '../../domain/entities/saved_route.dart';

class SavedRouteDTO extends SavedRoute {
  const SavedRouteDTO({
    required super.id,
    required super.originCode,
    required super.destinationCode,
    required super.originName,
    required super.destinationName,
    required super.note,
    required super.dailyTrainsCount,
  });

  factory SavedRouteDTO.fromJson(Map<String, dynamic> json) {
    return SavedRouteDTO(
      id: json['id'] ?? '',
      originCode: json['originCode'] ?? '',
      destinationCode: json['destinationCode'] ?? '',
      originName: json['originName'] ?? '',
      destinationName: json['destinationName'] ?? '',
      note: json['note'] ?? '',
      dailyTrainsCount: json['dailyTrainsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originCode': originCode,
      'destinationCode': destinationCode,
      'originName': originName,
      'destinationName': destinationName,
      'note': note,
      'dailyTrainsCount': dailyTrainsCount,
    };
  }
}
