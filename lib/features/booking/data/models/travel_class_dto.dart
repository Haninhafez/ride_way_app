import 'package:ride_way_app/features/booking/domain/entities/travel_class.dart';

class TravelClassDTO extends TravelClass {
  const TravelClassDTO({
    required super.id,
    required super.title,
    required super.price,
    required super.availableSeats,
    required super.perks,
    required super.defaultCoachNumber,
  });

  factory TravelClassDTO.fromFirestore(Map<String, dynamic> map) {
    final classId = (map['classId'] as String?) ?? '';

    return TravelClassDTO(
      id: classId,
      title: (map['className'] as String?) ?? _defaultTitle(classId),
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      availableSeats: (map['seatsAvailable'] as num?)?.toInt() ?? 0,
      perks: _defaultPerks(classId),
      defaultCoachNumber: _defaultCoach(classId),
    );
  }

  static String _defaultTitle(String classId) {
    switch (classId) {
      case 'economy':
        return 'Economy';
      case 'business':
        return 'Business';
      case 'first':
        return 'First Class';
      default:
        return classId;
    }
  }

  static List<String> _defaultPerks(String classId) {
    switch (classId) {
      case 'economy':
        return [
          'Standard comfortable seat',
          'Complimentary Wi-Fi',
          '1× 23 kg luggage',
        ];
      case 'business':
        return [
          'Priority boarding & lounge access',
          'Extra legroom & wide recline',
          'Complimentary hot meal & beverages',
          'Power outlet at every seat',
        ];
      case 'first':
        return [
          'Private suite seating',
          'Gourmet dining menu',
          '2× 32 kg luggage + priority handling',
          'Dedicated steward service',
        ];
      default:
        return [];
    }
  }

  static String _defaultCoach(String classId) {
    switch (classId) {
      case 'first':
        return '1';
      case 'business':
        return '3';
      default:
        return '6';
    }
  }

  @override
  String toString() =>
      'TravelClassDTO(id: $id, title: $title, '
      'price: $price, seats: $availableSeats)';
}
