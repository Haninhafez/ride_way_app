import '../entities/trip_notification.dart';

abstract class NotificationsRepository {
  Future<List<TripNotification>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
}
