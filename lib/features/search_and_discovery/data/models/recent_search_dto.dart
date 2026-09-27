import '../../domain/entities/recent_search.dart';

class RecentSearchDTO extends RecentSearch {
  const RecentSearchDTO({
    required super.id,
    required super.originCode,
    required super.destinationCode,
    required super.originName,
    required super.destinationName,
    required super.departureDate,
    required super.passengerCount,
  });

  factory RecentSearchDTO.fromJson(Map<String, dynamic> json) {
    return RecentSearchDTO(
      id: json['id'] ?? '',
      originCode: json['originCode'] ?? '',
      destinationCode: json['destinationCode'] ?? '',
      originName: json['originName'] ?? '',
      destinationName: json['destinationName'] ?? '',
      departureDate: DateTime.tryParse(json['departureDate'] ?? '') ?? DateTime.now(),
      passengerCount: json['passengerCount'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originCode': originCode,
      'destinationCode': destinationCode,
      'originName': originName,
      'destinationName': destinationName,
      'departureDate': departureDate.toIso8601String(),
      'passengerCount': passengerCount,
    };
  }
}
