import '../../domain/entities/trip_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/trips_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final TripsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<TripNotification>> getNotifications() {
    return remoteDataSource.fetchNotifications();
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return remoteDataSource.markNotificationRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() async {
    final list = await getNotifications();
    for (final n in list) {
      await remoteDataSource.markNotificationRead(n.id);
    }
  }
}
