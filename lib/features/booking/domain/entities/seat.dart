import 'package:equatable/equatable.dart';

enum SeatType { standard, window, aisle, accessible }

class Seat extends Equatable {
  final String seatNumber; 
  final String coachNumber; 
  final bool isOccupied;
  final double price;
  final SeatType type;
  final bool isAccessible;

  const Seat({
    required this.seatNumber,
    required this.coachNumber,
    required this.isOccupied,
    required this.price,
    this.type = SeatType.standard,
    this.isAccessible = false,
  });

int get rowKey {
  final numString = seatNumber.replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(numString) ?? 0;
}

String get column => seatNumber.replaceAll(RegExp(r'[^A-Z]'), '');



  Seat copyWith({
    String? seatNumber,
    String? coachNumber,
    bool? isOccupied,
    double? price,
    SeatType? type,
    bool? isAccessible,
  }) {
    return Seat(
      seatNumber: seatNumber ?? this.seatNumber,
      coachNumber: coachNumber ?? this.coachNumber,
      isOccupied: isOccupied ?? this.isOccupied,
      price: price ?? this.price,
      type: type ?? this.type,
      isAccessible: isAccessible ?? this.isAccessible,
    );
  }

  @override
  List<Object?> get props => [
        seatNumber,
        coachNumber,
        isOccupied,
        price,
        type,
        isAccessible,
      ];
}