import 'package:equatable/equatable.dart';

enum SupportChannelType { call, liveChat, email }

class SupportChannel extends Equatable {
  final SupportChannelType type;
  final String availabilityText;
  final String actionUrl;

  const SupportChannel({
    required this.type,
    required this.availabilityText,
    required this.actionUrl,
  });

  @override
  List<Object?> get props => [type, availabilityText, actionUrl];
}
