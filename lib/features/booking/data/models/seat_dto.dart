import 'package:ride_way_app/features/booking/domain/entities/seat.dart';

class SeatDTO extends Seat {
  const SeatDTO({
    required super.seatNumber,
    required super.coachNumber,
    required super.isOccupied,
    required super.price,
    super.type,
    super.isAccessible,
  });

  factory SeatDTO.fromFirestore(
    String id,
    Map<String, dynamic> map, {
    double classPrice = 0.0,
    String coachNumber = '',
  }) {
    final status = (map['status'] as String?) ?? 'available';
    final column = (map['column'] as String?) ?? '';

    return SeatDTO(
      seatNumber: (map['seatNumber'] as String?)?.isNotEmpty == true
          ? map['seatNumber'] as String
          : id,
      coachNumber: coachNumber,
      isOccupied: status != 'available',
      price: classPrice,
      type: _seatType(column),
      isAccessible: false,
    );
  }

  static SeatType _seatType(String column) {
    switch (column) {
      case 'A':
      case 'D':
        return SeatType.window;
      case 'B':
      case 'C':
        return SeatType.aisle;
      default:
        return SeatType.standard;
    }
  }

  @override
  String toString() =>
      'SeatDTO(seatNumber: $seatNumber, coach: $coachNumber, '
      'occupied: $isOccupied, price: $price, type: ${type.name})';
}
