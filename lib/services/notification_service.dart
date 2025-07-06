import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifier = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifier.initialize(settings);
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'channelId', 'channelName', importance: Importance.max);
    const details = NotificationDetails(android: androidDetails);
    await _notifier.show(0, title, body, details);
  }
}
