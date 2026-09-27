import '../../domain/entities/trip_notification.dart';

class NotificationDTO extends TripNotification {
  const NotificationDTO({
    required super.id,
    required super.type,
    required super.title,
    required super.message,
    required super.timestamp,
    super.isUnread,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) {
    return NotificationDTO(
      id: json['id'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.confirmation,
      ),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isUnread: json['isUnread'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isUnread': isUnread,
    };
  }
}
