import '../../domain/entities/travel_class.dart';

class TravelClassModel extends TravelClass {
  const TravelClassModel({
    required super.id,
    required super.title,
    required super.price,
    required super.availableSeats,
    required super.perks,
    required super.defaultCoachNumber,
  });

  factory TravelClassModel.fromJson(Map<String, dynamic> json) {
    return TravelClassModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      availableSeats: json['availableSeats'] ?? 0,
      perks: List<String>.from(json['perks'] ?? []),
      defaultCoachNumber: json['defaultCoachNumber'] ?? '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'availableSeats': availableSeats,
      'perks': perks,
      'defaultCoachNumber': defaultCoachNumber,
    };
  }
}
