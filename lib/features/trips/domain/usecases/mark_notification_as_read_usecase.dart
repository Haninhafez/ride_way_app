import '../repositories/notifications_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationsRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> markAsRead(String id) {
    return repository.markAsRead(id);
  }

  Future<void> markAllAsRead() {
    return repository.markAllAsRead();
  }
}
