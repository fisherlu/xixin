import "package:flutter/material.dart";
import "../../core/router/app_router.dart";
import "../../core/theme/app_colors.dart";
import "../../core/storage/hive_service.dart";
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
        title: Row(children: [
          Expanded(child: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600))),
          if (s.isPremium)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.accent.withValues(alpha: 0.15)),
              child: const Text('会员', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w600)),
            ),
        ]),
        subtitle: Text("${s.narrator ?? ''}  ·  ${s.durationText}", style: const TextStyle(fontSize: 13)),
        trailing: s.isPremium ? const Icon(Icons.lock, color: AppColors.accent, size: 16) : null,
        onTap: () {
          if (s.isPremium && !HiveService.isPremium) {
            _showPremiumDialog(context, s.title);
            return;
          }
          Navigator.pushNamed(context, AppRouter.sleepPlayer, arguments: s);
        },
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primary.withValues(alpha: 0.1)),
          child: const Icon(Icons.self_improvement, color: AppColors.primary),
        ),
        title: Row(children: [
          Expanded(child: Text(m.title, style: const TextStyle(fontWeight: FontWeight.w600))),
          if (m.isPremium)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.accent.withValues(alpha: 0.15)),
              child: const Text('会员', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w600)),
            ),
        ]),
        subtitle: Text(m.durationText, style: const TextStyle(fontSize: 13)),
        onTap: () {
          if (m.isPremium && !HiveService.isPremium) {
            _showPremiumDialog(context, m.title);
            return;
          }
          Navigator.pushNamed(context, AppRouter.meditationPlayer, arguments: m);
        },
      ),
    );
  }

  void _showPremiumDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.lock, color: AppColors.accent),
          SizedBox(width: 8),
          Text('会员专属'),
        ]),
        content: Text('「$title」是高级会员内容。\n\n升级会员即可畅享全部睡前故事与冥想课程。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('以后再说')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, AppRouter.subscription);
            },
            child: const Text('升级会员'),
          ),
        ],
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