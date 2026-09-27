import 'package:equatable/equatable.dart';

class TravelClass extends Equatable {
  final String id;
  final String title;
  final double price;
  final int availableSeats;
  final List<String> perks;
  final String defaultCoachNumber;

  const TravelClass({
    required this.id,
    required this.title,
    required this.price,
    required this.availableSeats,
    required this.perks,
    required this.defaultCoachNumber,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        availableSeats,
        perks,
        defaultCoachNumber,
      ];
}
