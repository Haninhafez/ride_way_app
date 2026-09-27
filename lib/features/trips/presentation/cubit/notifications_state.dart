import 'package:equatable/equatable.dart';
import '../../domain/entities/trip_notification.dart';

enum NotificationsStatus { initial, loading, success, error }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<TripNotification> allNotifications;
  final int selectedFilterTab; // 0: All, 1: Unread
  final String? errorMessage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.allNotifications = const [],
    this.selectedFilterTab = 0,
    this.errorMessage,
  });

  List<TripNotification> get unreadNotifications =>
      allNotifications.where((n) => n.isUnread).toList();

  List<TripNotification> get activeFilteredNotifications {
    if (selectedFilterTab == 1) {
      return unreadNotifications;
    }
    return allNotifications;
  }

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<TripNotification>? allNotifications,
    int? selectedFilterTab,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      allNotifications: allNotifications ?? this.allNotifications,
      selectedFilterTab: selectedFilterTab ?? this.selectedFilterTab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allNotifications,
        selectedFilterTab,
        errorMessage,
      ];
}
