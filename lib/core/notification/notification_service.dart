import "dart:async";
import "package:flutter_local_notifications/flutter_local_notifications.dart";

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static Timer? _timer;
  static int _notificationId = 0;

  static Future<void> init() async {
    const android = AndroidInitializationDetails('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
  }

  /// Schedule a daily reminder at the specified hour:minute
  /// Uses both periodic notifications (background) and Timer (foreground precision)
  static Future<void> scheduleDailyReminder(int hour, int minute) async {
    await cancelAll();

    // Periodic notification — works when app is in background/killed
    await _plugin.periodicallyShow(
      100, // fixed ID for daily reminder
      '息心冥想',
      '该冥想啦 —— 花几分钟回到当下，善待自己的心。',
      RepeatInterval.daily,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meditation_reminder',
          '冥想提醒',
          channelDescription: '每日冥想练习提醒',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    // Timer for precise timing while app is in foreground
    _schedulePreciseTimer(hour, minute);
  }

  static void _schedulePreciseTimer(int hour, int minute) {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour, minute);
    if (next.isBefore(now) || next.difference(now).inMinutes < 1) {
      next = next.add(const Duration(days: 1));
    }
    final delay = next.difference(now);

    _timer?.cancel();
    _timer = Timer(delay, () async {
      await _showImmediateNotification();
      _schedulePreciseTimer(hour, minute);
    });
  }

  static Future<void> _showImmediateNotification() async {
    _notificationId++;
    await _plugin.show(
      _notificationId,
      '息心冥想',
      '该冥想啦 —— 花几分钟回到当下，善待自己的心。',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meditation_reminder',
          '冥想提醒',
          channelDescription: '每日冥想练习提醒',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> cancelAll() async {
    _timer?.cancel();
    _timer = null;
    await _plugin.cancelAll();
  }
}