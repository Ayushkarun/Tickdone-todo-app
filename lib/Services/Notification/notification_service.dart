// notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  ///initialization
  Future<void> initNotification() async {
    if (_isInitialized) return;
    tz.initializeTimeZones();

    await _requestNotificationPermission();

    const initSettingsAndroid = AndroidInitializationSettings(
      '@drawable/notification',
    );
    const initSetting = InitializationSettings(android: initSettingsAndroid);

    await notificationsPlugin.initialize(initSetting);
    _isInitialized = true;
  }

  //  permission handling
  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  //Details setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notification',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  //show an immediate notifiaction
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  // MODIFIED: This method now takes a specific time to schedule the notification.
  Future<void> scheduleNotificationAtTime({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    var androidDetails = const AndroidNotificationDetails(
      'important_notification',
      'My Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      // We convert the chosen DateTime to a timezone-aware DateTime
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

    );
  }
}