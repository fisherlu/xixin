enum MeditationCategory { focus, stress, sleep, morning, compassion, body }

class Meditation {
  final String id;
  final String title;
  final String description;
  final String audioAsset;
  final int durationMinutes;
  final MeditationCategory category;
  final String? narrator;
  final String? imageAsset;
  final bool isPremium;
  final String? scriptAsset;

  const Meditation({
    required this.id,
    required this.title,
    required this.description,
    required this.audioAsset,
    required this.durationMinutes,
    required this.category,
    this.narrator,
    this.imageAsset,
    this.isPremium = false,
    this.scriptAsset,
  });

  String get durationText {
    if (durationMinutes < 60) return "";
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    return m == 0 ? "" : "";
  }
}

// ── Sample content data (placeholders until real audio) ──
class MeditationLibrary {
  MeditationLibrary._();

  static const List<Meditation> meditations = [
    Meditation(
      id: "morning_wake",
      title: "晨间唤醒冥想",
      description: "迎接新的一天，用正念开启清醒的早晨",
      audioAsset: "assets/audio/meditations/morning_wake.mp3",
      durationMinutes: 10,
      category: MeditationCategory.morning,
      narrator: "林静",
      scriptAsset: "assets/scripts/01_morning_wake.md",
    ),
    Meditation(
      id: "sleep_relax",
      title: "睡前放松冥想",
      description: "释放一天的疲备，进入安宁的梦乡",
      audioAsset: "assets/audio/meditations/sleep_relax.mp3",
      durationMinutes: 15,
      category: MeditationCategory.sleep,
      narrator: "林静",
      scriptAsset: "assets/scripts/02_sleep_relax.md",
    ),
    Meditation(
      id: "body_scan",
      title: "身体扫描",
      description: "从头到脚，感受身体的每一个部位",
      audioAsset: "assets/audio/meditations/body_scan.mp3",
      durationMinutes: 20,
      category: MeditationCategory.body,
      narrator: "林静",
      isPremium: true,
      scriptAsset: "assets/scripts/03_body_scan.md",
    ),
    Meditation(
      id: "focus_breath",
      title: "专注力冥想",
      description: "通过呼吸锚定当下，提升专注力",
      audioAsset: "assets/audio/meditations/focus_breath.mp3",
      durationMinutes: 10,
      category: MeditationCategory.focus,
      narrator: "林静",
      scriptAsset: "assets/scripts/04_focus.md",
    ),
    Meditation(
      id: "compassion",
      title: "慈悲冥想",
      description: "培养对自己和他人的善意与慈悲",
      audioAsset: "assets/audio/meditations/compassion.mp3",
      durationMinutes: 15,
      category: MeditationCategory.compassion,
      narrator: "林静",
      isPremium: true,
      scriptAsset: "assets/scripts/08_compassion.md",
    ),
    Meditation(
      id: "anxiety_relief",
      title: "焦虑缓解",
      description: "当焦虑来袭，让呼吸带你回到当下",
      audioAsset: "assets/audio/meditations/anxiety_relief.mp3",
      durationMinutes: 15,
      category: MeditationCategory.stress,
      narrator: "林静",
      scriptAsset: "assets/scripts/05_anxiety_relief.md",
    ),
    Meditation(
      id: "lunch_break",
      title: "午休小憩",
      description: "午间快速恢复精力，充电下午",
      audioAsset: "assets/audio/meditations/lunch_break.mp3",
      durationMinutes: 10,
      category: MeditationCategory.stress,
      scriptAsset: "assets/scripts/06_lunch_break.md",
    ),
    Meditation(
      id: "breath_awareness",
      title: "呼吸觉察",
      description: "观察呼吸的自然流动，不加干预",
      audioAsset: "assets/audio/meditations/breath_awareness.mp3",
      durationMinutes: 15,
      category: MeditationCategory.focus,
      scriptAsset: "assets/scripts/07_breath_awareness.md",
    ),
    Meditation(
      id: "gratitude",
      title: "感恩冥想",
      description: "回顾生活中值得感恩的瞬间",
      audioAsset: "assets/audio/meditations/gratitude.mp3",
      durationMinutes: 10,
      category: MeditationCategory.compassion,
      isPremium: true,
      scriptAsset: "assets/scripts/09_gratitude.md",
    ),
    Meditation(
      id: "deep_relax",
      title: "深度放松",
      description: "全身深度放松，重新连接内在平静",
      audioAsset: "assets/audio/meditations/deep_relax.mp3",
      durationMinutes: 30,
      category: MeditationCategory.sleep,
      narrator: "林静",
      isPremium: true,
      scriptAsset: "assets/scripts/10_deep_relax.md",
    ),
  ];
}