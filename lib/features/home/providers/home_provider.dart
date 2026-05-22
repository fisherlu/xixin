import "package:flutter/foundation.dart";
import "../../../core/storage/hive_service.dart";

class HomeProvider extends ChangeNotifier {
  String get greeting {
    final h = DateTime.now().hour;
    if (h < 6) return "深夜好";
    if (h < 9) return "早上好";
    if (h < 12) return "上午好";
    if (h < 14) return "中午好";
    if (h < 18) return "下午好";
    return "晚上好";
  }
  int get streakDays => HiveService.streakDays;
  int get totalMinutes => HiveService.totalMinutes;
  int get totalSessions => HiveService.meditationHistory.length;
}
