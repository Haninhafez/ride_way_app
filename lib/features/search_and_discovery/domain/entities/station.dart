import 'package:equatable/equatable.dart';

class Station extends Equatable {
  final String stationCode;
  final String name;
  final String city;

  const Station({
    required this.stationCode,
    required this.name,
    required this.city,
  });

  @override
  List<Object?> get props => [stationCode, name, city];
}
