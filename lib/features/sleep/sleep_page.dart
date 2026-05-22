import "package:flutter/material.dart";
import "../../core/router/app_router.dart";
import "../../core/theme/app_colors.dart";
import "../../shared/models/sleep_story.dart";
import "../../shared/models/meditation.dart";

class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sleepMeds = MeditationLibrary.meditations.where((m) => m.category == MeditationCategory.sleep).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("睡眠")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("睡眠故事", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...SleepStoryLibrary.stories.map((s) => _storyCard(context, s, theme)),
          const SizedBox(height: 24),
          Text("睡前冥想", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...sleepMeds.map((m) => _sleepMedCard(context, m, theme)),
          const SizedBox(height: 24),
          Text("白噪音", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _ambientGrid(context),
        ]),
      ),
    );
  }

  Widget _storyCard(BuildContext context, SleepStory s, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFF1B4332)),
          child: const Icon(Icons.nightlight_round, color: Colors.white70),
        ),
        title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("${s.narrator ?? ''}  ·  ${s.durationText}", style: const TextStyle(fontSize: 13)),
        trailing: s.isPremium ? const Icon(Icons.star, color: AppColors.accent, size: 18) : null,
        onTap: () => Navigator.pushNamed(context, AppRouter.sleepPlayer, arguments: s),
      ),
    );
  }

  Widget _sleepMedCard(BuildContext context, Meditation m, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primary.withOpacity(0.1)),
          child: const Icon(Icons.self_improvement, color: AppColors.primary),
        ),
        title: Text(m.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(m.durationText, style: const TextStyle(fontSize: 13)),
        onTap: () => Navigator.pushNamed(context, AppRouter.meditationPlayer, arguments: m),
      ),
    );
  }

  Widget _ambientGrid(BuildContext context) {
    final sounds = [
      {"icon": Icons.water_drop, "label": "雨声"},
      {"icon": Icons.forest, "label": "森林"},
      {"icon": Icons.waves, "label": "浪潮"},
      {"icon": Icons.fireplace, "label": "壁炉"},
      {"icon": Icons.temple_buddhist, "label": "钟声"},
    ];
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: sounds.map((s) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            width: 100, height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).cardColor),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(s["icon"] as IconData, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(s["label"] as String, style: const TextStyle(fontSize: 13)),
            ]),
          ),
        );
      }).toList(),
    );
  }
}
