import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'rideway_trip_reminders';

  Future<void> initialize() async {
    tz.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings: settings);

    const channel = AndroidNotificationChannel(
      channelId,
      'Trip Reminders',
      description: 'Reminders before train departure',
      importance: Importance.max,
    );

    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.createNotificationChannel(channel);
    await android?.requestNotificationsPermission();

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) return;

      await showTestNotification(
        title: notification.title ?? 'New notification',
        body: notification.body ?? '',
      );
    });
  }

  Future<String?> getToken() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  // Test: show a notification immediately.
  Future<void> showTestNotification({
    String title = 'RideWay Test',
    String body = 'Notifications are working!',
  }) async {
    await _notifications.show(
      id: 99,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Trip Reminders',
          channelDescription: 'Reminders before train departure',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  // Schedule a reminder one hour before departure.
  Future<void> scheduleTripReminder({
    required int notificationId,
    required String tripName,
    required DateTime departureTime,
  }) async {
    final reminderTime = departureTime.subtract(const Duration(hours: 1));

    debugPrint('Departure: $departureTime');
    debugPrint('Reminder time: $reminderTime');
    debugPrint('Current time: ${DateTime.now()}');

    if (!reminderTime.isAfter(DateTime.now())) {
      debugPrint('Reminder NOT scheduled: time is in the past.');
      return;
    }

    await _notifications.zonedSchedule(
      id: notificationId,
      title: 'Upcoming trip reminder 🚆',
      body: 'Your trip $tripName starts in one hour.',
      scheduledDate: tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'rideway_trip_reminders',
          'Trip Reminders',
          channelDescription: 'Reminders before train departure',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    debugPrint('Reminder scheduled successfully!');
  }
}
