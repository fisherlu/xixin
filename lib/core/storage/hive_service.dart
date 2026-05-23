import "package:hive_flutter/hive_flutter.dart";

class HiveService {
  HiveService._();

  static late Box _settingsBox;
  static late Box _meditationBox;
  static late Box _achievementsBox;

  static Future<void> init() async {
    _settingsBox = await Hive.openBox("settings");
    _meditationBox = await Hive.openBox("meditation_history");
    _achievementsBox = await Hive.openBox("achievements");
  }

  // ── Settings ──
  static String get locale => _settingsBox.get("locale", defaultValue: "zh_CN");
  static set locale(String v) => _settingsBox.put("locale", v);

  static bool get reminderEnabled => _settingsBox.get("reminder", defaultValue: false);
  static set reminderEnabled(bool v) => _settingsBox.put("reminder", v);

  static String get reminderTime => _settingsBox.get("reminderTime", defaultValue: "08:00");
  static set reminderTime(String v) => _settingsBox.put("reminderTime", v);

  // ── Meditation History ──
  static List<Map> get meditationHistory {
    final raw = _meditationBox.get("sessions", defaultValue: <Map>[]);
    return List<Map>.from(raw);
  }

  static Future<void> addMeditationSession(Map session) async {
    final sessions = meditationHistory;
    sessions.insert(0, session);
    await _meditationBox.put("sessions", sessions);
  }

  static int get totalMinutes {
    return meditationHistory.fold<int>(
      0,
      (sum, s) => sum + ((s["durationSeconds"] as int?) ?? 0),
    ) ~/ 60;
  }

  static int get streakDays {
    final sessions = meditationHistory;
    if (sessions.isEmpty) return 0;
    int streak = 0;
    DateTime? lastDate;
    for (final s in sessions) {
      final dateStr = s["date"] as String?;
      if (dateStr == null) continue;
      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;
      if (lastDate == null) {
        streak = 1;
        lastDate = date;
        continue;
      }
      final diff = lastDate.difference(date).inDays;
      if (diff == 1) {
        streak++;
        lastDate = date;
      } else {
        break;
      }
    }
    return streak;
  }

  // ── Achievements ──
  static bool hasAchievement(String id) =>
      _achievementsBox.get(id, defaultValue: false);

  static Future<void> unlockAchievement(String id) async {
    await _achievementsBox.put(id, true);
  }

  static Set<String> get unlockedAchievements {
    final keys = _achievementsBox.keys.cast<String>();
    return keys.where((k) => _achievementsBox.get(k) == true).toSet();
  }
}

  // ── Auth ──
  static bool get isLoggedIn => _settingsBox.get('loggedIn', defaultValue: false);
  static set isLoggedIn(bool v) => _settingsBox.put('loggedIn', v);

  static String get userName => _settingsBox.get('userName', defaultValue: '');
  static set userName(String v) => _settingsBox.put('userName', v);

  static String get userEmail => _settingsBox.get('userEmail', defaultValue: '');
  static set userEmail(String v) => _settingsBox.put('userEmail', v);

  static String get userPhone => _settingsBox.get('userPhone', defaultValue: '');
  static set userPhone(String v) => _settingsBox.put('userPhone', v);

  // ── Premium ──
  static bool get isPremium => _settingsBox.get('isPremium', defaultValue: false);
  static set isPremium(bool v) => _settingsBox.put('isPremium', v);

  static String get premiumExpiry => _settingsBox.get('premiumExpiry', defaultValue: '');
  static set premiumExpiry(String v) => _settingsBox.put('premiumExpiry', v);

  static int get trialDaysLeft {
    final start = _settingsBox.get('trialStart', defaultValue: '');
    if (start == '') return 0;
    final elapsed = DateTime.now().difference(DateTime.parse(start)).inDays;
    return (7 - elapsed).clamp(0, 7);
  }

  static void startTrial() {
    _settingsBox.put('trialStart', DateTime.now().toIso8601String());
  }

  // ── Onboarding ──
  static bool get onboardingDone => _settingsBox.get("onboardingDone", defaultValue: false);
  static set onboardingDone(bool v) => _settingsBox.put("onboardingDone", v);