import 'package:flutter_test/flutter_test.dart';
import 'package:ride_way_app/core/notifications/notification_service.dart';

DateTime getReminderTime(DateTime departureTime) {
  return departureTime.subtract(const Duration(hours: 1));
}

void main() {
  late NotificationService service;

  setUp(() {
    service = NotificationService();
  });

  group('Reminder time tests', () {
    test('should schedule reminder one hour before departure', () {
      final departureTime = DateTime(2026, 10, 30, 10, 0);

      final reminderTime = service.scheduleTripReminder(
        departureTime: getReminderTime(departureTime),
        tripName: "Hello",
        notificationId: 1
      );

      expect(reminderTime, DateTime(2026, 10, 30, 9, 0));
    });
  });
}
