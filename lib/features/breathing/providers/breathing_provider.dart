import "dart:async";
import "package:flutter/foundation.dart";
import "../../../shared/models/breathing_pattern.dart";

enum BreathingPhase { inhale, holdAfterInhale, exhale, holdAfterExhale, ready }

class BreathingProvider extends ChangeNotifier {
  BreathingPattern? _pattern;
  BreathingPhase _phase = BreathingPhase.ready;
  int _currentCycle = 0;
  int _phaseSecondsLeft = 0;
  Timer? _timer;
  bool _isRunning = false;

  BreathingPattern? get pattern => _pattern;
  BreathingPhase get phase => _phase;
  int get currentCycle => _currentCycle;
  int get phaseSecondsLeft => _phaseSecondsLeft;
  bool get isRunning => _isRunning;

  String get phaseLabel {
    switch (_phase) {
      case BreathingPhase.inhale: return "吸气";
      case BreathingPhase.holdAfterInhale: return "屏气";
      case BreathingPhase.exhale: return "呼气";
      case BreathingPhase.holdAfterExhale: return "悬止";
      case BreathingPhase.ready: return "准备";
    }
  }

  void selectPattern(BreathingPattern p) {
    _pattern = p;
    _phase = BreathingPhase.ready;
    _currentCycle = 0;
    _isRunning = false;
    notifyListeners();
  }

  void start() {
    if (_pattern == null) return;
    _isRunning = true;
    _currentCycle = 0;
    _runCycle();
  }

  void _runCycle() {
    if (!_isRunning || _pattern == null) return;
    _currentCycle++;
    if (_currentCycle > _pattern!.cycles) { stop(); return; }
    _runPhase(0);
  }

  void _runPhase(int phaseIdx) {
    if (!_isRunning || _pattern == null) return;
    final p = _pattern!.holdPatterns;
    if (phaseIdx >= p.length) { _runCycle(); return; }
    _phaseSecondsLeft = p[phaseIdx];
    if (phaseIdx == 0) { _phase = BreathingPhase.inhale; }
    else if (phaseIdx == 1) { _phase = BreathingPhase.holdAfterInhale; }
    else if (phaseIdx == 2) { _phase = BreathingPhase.exhale; }
    else { _phase = BreathingPhase.holdAfterExhale; }
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _phaseSecondsLeft--;
      if (_phaseSecondsLeft <= 0) { t.cancel(); _runPhase(phaseIdx + 1); }
      notifyListeners();
    });
  }

  void stop() { _timer?.cancel(); _isRunning = false; _phase = BreathingPhase.ready; notifyListeners(); }
  void reset() { _timer?.cancel(); _phase = BreathingPhase.ready; _currentCycle = 0; _isRunning = false; notifyListeners(); }

  @override void dispose() { _timer?.cancel(); super.dispose(); }
}