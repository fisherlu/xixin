import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/achievement.dart';
import 'providers/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProfileProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          _statsSection(context, pp, theme),
          const SizedBox(height: 32),
          _achievementSection(context, pp, theme),
          const SizedBox(height: 32),
          _settingsSection(context, pp, theme),
        ]),
      ),
    );
  }

  Widget _statsSection(BuildContext ctx, ProfileProvider pp, ThemeData t) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _statCard(t, '连续天数', '${pp.streakDays}', Icons.local_fire_department, AppColors.accent),
      _statCard(t, '总分钟数', '${pp.totalMinutes}', Icons.timer, AppColors.primary),
      _statCard(t, '冥想次数', '${pp.totalSessions}', Icons.self_improvement, const Color(0xFF52B788)),
    ]);
  }

  Widget _statCard(ThemeData t, String label, String value, IconData icon, Color color) {
    return Column(children: [
      Icon(icon, color: color, size: 28), const SizedBox(height: 8),
      Text(value, style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
      Text(label, style: t.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
    ]);
  }

  Widget _achievementSection(BuildContext ctx, ProfileProvider pp, ThemeData t) {
    final achievements = pp.achievements;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('成就勋章', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        Text('${achievements.length}/${AchievementLibrary.list.length}',
          style: t.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ]),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: pp.achievementProgress, minHeight: 4,
          backgroundColor: t.cardColor,
          valueColor: const AlwaysStoppedAnimation(AppColors.accent),
        ),
      ),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: [
        ...AchievementLibrary.list.map((a) => _achievementBadge(ctx, t, a, achievements.any((ua) => ua.id == a.id))),
      ]),
    ]);
  }

  Widget _achievementBadge(BuildContext ctx, ThemeData t, Achievement a, bool unlocked) {
    return Container(
      width: (MediaQuery.of(ctx).size.width - 64) / 4,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: t.cardColor,
        border: unlocked ? Border.all(color: a.color.withValues(alpha: 0.3)) : null,
      ),
      child: Column(children: [
        Icon(a.icon, color: unlocked ? a.color : AppColors.textSecondary.withValues(alpha: 0.3), size: 24),
        const SizedBox(height: 8),
        Text(a.title, style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600,
          color: unlocked ? null : AppColors.textSecondary.withValues(alpha: 0.3),
        ), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _settingsSection(BuildContext ctx, ProfileProvider pp, ThemeData t) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('设置', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Card(child: Column(children: [
        SwitchListTile(
          title: const Text('冥想提醒'),
          subtitle: Text(pp.reminderEnabled ? '每天 ${pp.reminderTime}' : '关闭'),
          value: pp.reminderEnabled, onChanged: pp.toggleReminder,
        ),
        const Divider(height: 1),
        ListTile(title: const Text('关于正念冥想'), subtitle: const Text('v1.0.0'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        const Divider(height: 1),
        ListTile(title: const Text('隐私政策'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
      ])),
    ]);
  }
}

