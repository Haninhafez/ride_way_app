import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
  }) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      final list = await getNotificationsUseCase.execute();
      emit(state.copyWith(
        status: NotificationsStatus.success,
        allNotifications: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void changeFilterTab(int index) {
    emit(state.copyWith(selectedFilterTab: index));
  }

  Future<void> markAllAsRead() async {
    await markNotificationAsReadUseCase.markAllAsRead();
    final updated = state.allNotifications.map((n) => n.copyWith(isUnread: false)).toList();
    emit(state.copyWith(allNotifications: updated));
  }

  Future<void> markAsRead(String id) async {
    await markNotificationAsReadUseCase.markAsRead(id);
    final updated = state.allNotifications.map((n) {
      return n.id == id ? n.copyWith(isUnread: false) : n;
    }).toList();
    emit(state.copyWith(allNotifications: updated));
  }
}
