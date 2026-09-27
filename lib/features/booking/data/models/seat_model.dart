import '../../domain/entities/seat.dart';

class SeatModel extends Seat {
  const SeatModel({
    required super.seatNumber,
    required super.coachNumber,
    required super.isOccupied,
    required super.price,
    super.type,
    super.isAccessible,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      seatNumber: json['seatNumber'] ?? '',
      coachNumber: json['coachNumber'] ?? '',
      isOccupied: json['isOccupied'] ?? false,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      type: SeatType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SeatType.standard,
      ),
      isAccessible: json['isAccessible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seatNumber': seatNumber,
      'coachNumber': coachNumber,
      'isOccupied': isOccupied,
      'price': price,
      'type': type.name,
      'isAccessible': isAccessible,
    };
  }
}
