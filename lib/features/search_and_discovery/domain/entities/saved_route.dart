import 'package:equatable/equatable.dart';

class SavedRoute extends Equatable {
  final String id;
  final String originCode;
  final String destinationCode;
  final String originName;
  final String destinationName;
  final String note;
  final int dailyTrainsCount;

  const SavedRoute({
    required this.id,
    required this.originCode,
    required this.destinationCode,
    required this.originName,
    required this.destinationName,
    required this.note,
    required this.dailyTrainsCount,
  });

  @override
  List<Object?> get props => [
        id,
        originCode,
        destinationCode,
        originName,
        destinationName,
        note,
        dailyTrainsCount,
      ];
}
