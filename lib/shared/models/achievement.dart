import "package:flutter/material.dart";

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.color = const Color(0xFFF4A261),
  });
}

class AchievementLibrary {
  AchievementLibrary._();

  static const list = [
    Achievement(
      id: "first_session",
      title: "开始之旅",
      description: "完成第一次冥想",
      icon: Icons.self_improvement,
    ),
    Achievement(
      id: "streak_3",
      title: "三日之约",
      description: "连续冥想3天",
      icon: Icons.local_fire_department,
    ),
    Achievement(
      id: "streak_7",
      title: "七日之旅",
      description: "连续冥想7天",
      icon: Icons.local_fire_department,
      color: Color(0xFFE76F51),
    ),
    Achievement(
      id: "streak_30",
      title: "月度修行",
      description: "连续冥想30天",
      icon: Icons.emoji_events,
      color: Color(0xFFFFD166),
    ),
    Achievement(
      id: "total_60",
      title: "惟度一小时",
      description: "累计冥想60分钟",
      icon: Icons.hourglass_bottom,
    ),
    Achievement(
      id: "total_600",
      title: "十小时浸润",
      description: "累计冥想10小时",
      icon: Icons.hourglass_full,
      color: Color(0xFF52B788),
    ),
    Achievement(
      id: "breath_master",
      title: "呼吸大师",
      description: "完成所有呼吸训练模式",
      icon: Icons.air,
    ),
    Achievement(
      id: "sleep_story_5",
      title: "梦乡旅人",
      description: "听完5个睡眠故事",
      icon: Icons.nightlight_round,
      color: Color(0xFF2D6A4F),
    ),
  ];
}
