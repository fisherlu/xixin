class BreathingPattern {
  final String id;
  final String title;
  final String description;
  final List<int> holdPatterns; // [inhale, hold1, exhale, hold2] in seconds
  final int cycles;

  const BreathingPattern({
    required this.id,
    required this.title,
    required this.description,
    required this.holdPatterns,
    required this.cycles,
  });

  int get totalSecondsPerCycle {
    return holdPatterns.fold(0, (sum, s) => sum + s);
  }

  String get phasesText {
    final p = holdPatterns;
    if (p.length == 4) {
      return "吸${p[0]}s · 屏${p[1]}s · 呼${p[2]}s · 屏${p[3]}s";
    }
    return holdPatterns.join("s · ") + "s";
  }
}

class BreathingLibrary {
  BreathingLibrary._();

  static const patterns = [
    BreathingPattern(
      id: "wim_hof",
      title: "Wim Hof 呼吸法",
      description:
          "通过强化呼吸激活身体，提升免疫力与精力",
      holdPatterns: [30, 0, -2, 0], // special: rapid inhale-exhale
      cycles: 3,
    ),
    BreathingPattern(
      id: "box",
      title: "箱式呼吸",
      description: "均匀的四步呼吸，有助于放松和专注",
      holdPatterns: [4, 4, 4, 4],
      cycles: 10,
    ),
    BreathingPattern(
      id: "478",
      title: "4-7-8 呼吸法",
      description: "帮助入睡的经典呼吸法，放松神经系统",
      holdPatterns: [4, 7, 8, 0],
      cycles: 8,
    ),
  ];
}
