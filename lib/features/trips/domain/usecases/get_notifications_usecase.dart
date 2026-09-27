import '../entities/trip_notification.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<TripNotification>> execute() {
    return repository.getNotifications();
  }
}
