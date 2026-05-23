import "dart:async";
import "package:flutter_local_notifications/flutter_local_notifications.dart";

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static Timer? _timer;

  static Future<void> init() async {
    const android = AndroidInitializationDetails('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
  }

  static Future<void> scheduleDailyReminder(int hour, int minute) async {
    cancelAll();
    _scheduleNext(hour, minute);
  }

  static void _scheduleNext(int hour, int minute) {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour, minute);
    if (next.isBefore(now) || next.difference(now).inMinutes < 1) {
      next = next.add(const Duration(days: 1));
    }
    final delay = next.difference(now);
    
    _timer?.cancel();
    _timer = Timer(delay, () async {
      await _showNotification();
      // Re-schedule for next day
      _scheduleNext(hour, minute);
    });
  }

  static Future<void> _showNotification() async {
    const android = AndroidNotificationDetails(
      'meditation_reminder',
      '冥想提醒',
      channelDescription: '每日冥想练习提醒',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);
    await _plugin.show(0, '息心冥想', '该冥想啦 —— 花几分钟回到当下，善待自己的心。', details);
  }

  static void cancelAll() {
    _timer?.cancel();
    _timer = null;
    _plugin.cancelAll();
  }
}