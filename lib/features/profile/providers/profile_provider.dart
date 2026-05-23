import "package:flutter/foundation.dart";
import "../../../core/storage/hive_service.dart";
import "../../../core/notification/notification_service.dart";
import "../../../shared/models/achievement.dart";

class ProfileProvider extends ChangeNotifier {
  int get streakDays => HiveService.streakDays;
  int get totalMinutes => HiveService.totalMinutes;
  int get totalSessions => HiveService.meditationHistory.length;
  bool get reminderEnabled => HiveService.reminderEnabled;
  String get reminderTime => HiveService.reminderTime;

  List<Achievement> get achievements {
    final u = HiveService.unlockedAchievements;
    return AchievementLibrary.list.where((a) => u.contains(a.id)).toList();
  }

  double get achievementProgress {
    if (AchievementLibrary.list.isEmpty) return 0;
    return achievements.length / AchievementLibrary.list.length;
  }

  Future<void> toggleReminder(bool v) async {
    HiveService.reminderEnabled = v;
    if (v) {
      _scheduleReminder();
    } else {
      NotificationService.cancelAll();
    }
    notifyListeners();
  }

  Future<void> setReminderTime(String t) async {
    HiveService.reminderTime = t;
    _scheduleReminder();
    notifyListeners();
  }

  void _scheduleReminder() {
    if (!HiveService.reminderEnabled) return;
    final parts = HiveService.reminderTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    NotificationService.scheduleDailyReminder(hour, minute);
  }
}