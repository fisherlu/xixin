import 'package:just_audio/just_audio.dart';
import "package:flutter/foundation.dart";
import "../../../core/audio/audio_service.dart";
import "../../../core/storage/hive_service.dart";
import "../../../shared/models/meditation.dart";

class MeditationProvider extends ChangeNotifier {
  final AudioService _audio = AudioService();
  Meditation? _current;
  bool _isPlaying = false;
  bool _isPaused = false;
  double _progress = 0;
  String? _ambientId;

  Meditation? get current => _current;
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  double get progress => _progress;
  AudioService get audio => _audio;
  String? get ambientId => _ambientId;

  double get durationSeconds {
    if (_current == null) return 0;
    return _current!.durationMinutes * 60.0;
  }

  Future<void> startMeditation(Meditation meditation) async {
    _current = meditation;
    _isPlaying = true;
    _isPaused = false;
    _progress = 0;
    notifyListeners();

    await _audio.playMeditation(meditation.audioAsset);

    _audio.positionStream.listen((pos) {
      _progress = pos;
      notifyListeners();
    });

    _audio.stateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _completeMeditation();
      }
    });
  }

  Future<void> setAmbient(String id, String path) async {
    _ambientId = id;
    await _audio.playAmbient(path);
    notifyListeners();
  }

  Future<void> clearAmbient() async {
    _ambientId = null;
    await _audio.stopAmbient();
    notifyListeners();
  }

  Future<void> pauseResume() async {
    if (_isPaused) {
      await _audio.play();
      _isPaused = false;
    } else {
      await _audio.pause();
      _isPaused = true;
    }
    notifyListeners();
  }

  Future<void> stop() async {
    await _audio.stop();
    _current = null;
    _isPlaying = false;
    _isPaused = false;
    _progress = 0;
    notifyListeners();
  }

  void _completeMeditation() async {
    if (_current == null) return;
    await HiveService.addMeditationSession({
      "id": _current!.id,
      "title": _current!.title,
      "durationSeconds": _current!.durationMinutes * 60,
      "date": DateTime.now().toIso8601String(),
    });
    _checkAchievements();
    _current = null;
    _isPlaying = false;
    _isPaused = false;
    _progress = 0;
    notifyListeners();
  }

  void _checkAchievements() async {
    final sessions = HiveService.meditationHistory;
    final totalMin = HiveService.totalMinutes;
    final streak = HiveService.streakDays;

    if (sessions.isNotEmpty && !HiveService.hasAchievement("first_session")) {
      await HiveService.unlockAchievement("first_session");
    }
    if (streak >= 3 && !HiveService.hasAchievement("streak_3")) {
      await HiveService.unlockAchievement("streak_3");
    }
    if (streak >= 7 && !HiveService.hasAchievement("streak_7")) {
      await HiveService.unlockAchievement("streak_7");
    }
    if (streak >= 30 && !HiveService.hasAchievement("streak_30")) {
      await HiveService.unlockAchievement("streak_30");
    }
    if (totalMin >= 60 && !HiveService.hasAchievement("total_60")) {
      await HiveService.unlockAchievement("total_60");
    }
  }
}



