import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';

enum MyBookingsStatus { initial, loading, success, error }

class MyBookingsState extends Equatable {
  final MyBookingsStatus status;
  final List<Booking> allBookings;
  final int selectedTabIndex; // 0: upcoming, 1: completed, 2: cancelled
  final String? errorMessage;

  const MyBookingsState({
    this.status = MyBookingsStatus.initial,
    this.allBookings = const [],
    this.selectedTabIndex = 0,
    this.errorMessage,
  });

  List<Booking> get upcomingBookings =>
      allBookings.where((b) => b.status == BookingStatusType.upcoming).toList();

  List<Booking> get completedBookings =>
      allBookings.where((b) => b.status == BookingStatusType.completed).toList();

  List<Booking> get cancelledBookings =>
      allBookings.where((b) => b.status == BookingStatusType.cancelled).toList();

  List<Booking> get activeFilteredBookings {
    switch (selectedTabIndex) {
      case 1:
        return completedBookings;
      case 2:
        return cancelledBookings;
      default:
        return upcomingBookings;
    }
  }

  MyBookingsState copyWith({
    MyBookingsStatus? status,
    List<Booking>? allBookings,
    int? selectedTabIndex,
    String? errorMessage,
  }) {
    return MyBookingsState(
      status: status ?? this.status,
      allBookings: allBookings ?? this.allBookings,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allBookings,
        selectedTabIndex,
        errorMessage,
      ];
}
