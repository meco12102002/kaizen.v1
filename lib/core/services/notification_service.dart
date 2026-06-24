import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(),
      windows: WindowsInitializationSettings(
        appName: 'Kaizen',
        appUserModelId: 'com.kaizen.app',
        guid: 'd2a4dbe6-4c4f-4b47-9c5e-9d1e5d7a8a11',
      ),
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  Future<void> scheduleTaskReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    if (scheduledAt.isBefore(DateTime.now())) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Alerts for upcoming and due tasks',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledAt, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelTaskReminder(int id) async {
    if (!_initialized) {
      await initialize();
    }
    await _plugin.cancel(id);
  }

  Future<void> showImmediateTestNotification() async {
    if (!_initialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'test_notifications',
      'Test Notifications',
      channelDescription: 'Quick checks for notification delivery',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      windows: WindowsNotificationDetails(
        appName: 'Kaizen',
        appUserModelId: 'com.kaizen.app',
      ),
    );

    await _plugin.show(
      999999,
      'Test notification',
      'If you can read this, notifications are working.',
      details,
    );
  }
}
