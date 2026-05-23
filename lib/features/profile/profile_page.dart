import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../core/theme/app_colors.dart";
import "../../core/router/app_router.dart";
import "../../core/storage/hive_service.dart";
import "../../shared/models/achievement.dart";
import "../auth/providers/auth_provider.dart";
import "providers/profile_provider.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProfileProvider>();
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final isPremium = HiveService.isPremium;

    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          _userCard(context, auth, isPremium, theme),
          const SizedBox(height: 24),
          _statsSection(context, pp, theme),
          const SizedBox(height: 24),
          if (!isPremium) _premiumBanner(context),
          const SizedBox(height: 24),
          _achievementSection(context, pp, theme),
          const SizedBox(height: 32),
          _settingsSection(context, pp, auth, theme),
        ]),
      ),
    );
  }

  Widget _userCard(BuildContext ctx, AuthProvider auth, bool isPremium, ThemeData t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isPremium ? [const Color(0xFFF4A261), const Color(0xFFE76F51)] : [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white24,
          child: Text(auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(auth.userName.isNotEmpty ? auth.userName : '用户', style: t.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(auth.userEmail.isNotEmpty ? auth.userEmail : (auth.userPhone.isNotEmpty ? auth.userPhone : ''), style: t.textTheme.bodySmall?.copyWith(color: Colors.white60)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white24),
          child: Text(isPremium ? '会员' : '免费', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _premiumBanner(BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(ctx, AppRouter.subscription),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [AppColors.accent.withValues(alpha: 0.2), AppColors.accentLight.withValues(alpha: 0.1)]),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        ),
        child: const Row(children: [
          Icon(Icons.workspace_premium, color: AppColors.accent),
          SizedBox(width: 12),
          Expanded(child: Text('升级会员，解锁全部高级内容', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600))),
          Icon(Icons.chevron_right, color: AppColors.accent),
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

  Widget _settingsSection(BuildContext ctx, ProfileProvider pp, AuthProvider auth, ThemeData t) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('设置', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Card(child: Column(children: [
        ListTile(
          leading: const Icon(Icons.workspace_premium, color: AppColors.accent),
          title: const Text('会员中心'),
          subtitle: Text(HiveService.isPremium ? '已激活' : '免费版'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(ctx, AppRouter.subscription),
        ),
        const Divider(height: 1),
        SwitchListTile(
          secondary: const Icon(Icons.notifications_outlined),
          title: const Text('冥想提醒'),
          subtitle: Text(pp.reminderEnabled ? '每天 ${pp.reminderTime}' : '关闭'),
          value: pp.reminderEnabled, onChanged: pp.toggleReminder,
        ),
        if (pp.reminderEnabled) ...[
          const Divider(height: 1),
          ListTile(
            leading: const SizedBox(width: 24),
            title: const Text('提醒时间'),
            trailing: GestureDetector(
              onTap: () => _pickTime(ctx, pp),
              child: Text(pp.reminderTime, style: t.textTheme.bodyLarge?.copyWith(color: AppColors.primary)),
            ),
          ),
        ],
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('关于息心冥想'),
          subtitle: const Text('v1.0.0 — 中文原生正念伴侣'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('隐私政策'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.error),
          title: const Text('退出登录'),
          onTap: () {
            showDialog(
              context: ctx,
              builder: (c) => AlertDialog(
                title: const Text('确认退出'),
                content: const Text('退出后需要重新登录'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(c), child: const Text('取消')),
                  TextButton(onPressed: () { Navigator.pop(c); auth.logout(); }, child: const Text('退出', style: TextStyle(color: AppColors.error))),
                ],
              ),
            );
          },
        ),
      ])),
    ]);
  }

  Future<void> _pickTime(BuildContext ctx, ProfileProvider pp) async {
    final parts = pp.reminderTime.split(':');
    final initial = TimeOfDay(hour: int.tryParse(parts[0]) ?? 8, minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0);
    final picked = await showTimePicker(context: ctx, initialTime: initial);
    if (picked != null) {
      pp.setReminderTime('${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
    }
  }
}