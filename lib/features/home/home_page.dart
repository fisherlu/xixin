import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../core/router/app_router.dart";
import "../../core/theme/app_colors.dart";
import "../../shared/models/meditation.dart";
import "../../shared/widgets/meditation_card.dart";
import "providers/home_provider.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeProvider>();
    final theme = Theme.of(context);
    final recommended = MeditationLibrary.meditations.first;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            _greeting(context, home, theme),
            const SizedBox(height: 24),
            _dailyQuote(theme),
            const SizedBox(height: 28),
            _statsRow(context, home, theme),
            const SizedBox(height: 28),
            _quickStart(context),
            const SizedBox(height: 28),
            _dailyCard(context, recommended, theme),
            const SizedBox(height: 20),
            _categories(context, theme),
            const SizedBox(height: 32),
          ]),
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _greeting(BuildContext ctx, HomeProvider h, ThemeData t) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(h.greeting, style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w300, color: AppColors.textSecondary)),
      const SizedBox(height: 4),
      Text("今天也要保持正念", style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
      if (h.streakDays > 0) ...[
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.local_fire_department, color: AppColors.accent, size: 20),
          const SizedBox(width: 4),
          Text("连续 ${h.streakDays} 天", style: t.textTheme.bodyMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
        ]),
      ],
    ]);
  }

  Widget _dailyQuote(ThemeData t) {
    final quotes = [
      "呼吸是连接身体与心灵的桥梁。",
      "你无法阻止波浪，但可以学会冲浪。",
      "当下时刻，是唯一真正存在的时间。",
      "平静不是没有风暴，而是在风暴中找到安宁。",
      "觉察呼吸，就是回到当下。",
    ];
    final quote = quotes[DateTime.now().day % quotes.length];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.primaryLight.withValues(alpha: 0.04)],
        ),
      ),
      child: Row(children: [
        const Icon(Icons.format_quote, color: AppColors.primaryLight, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(quote, style: t.textTheme.bodyLarge?.copyWith(color: AppColors.primaryDark, fontStyle: FontStyle.italic)),
        ),
      ]),
    );
  }

  Widget _statsRow(BuildContext ctx, HomeProvider h, ThemeData t) {
    return Row(children: [
      _miniStat(t, "总时长", "${h.totalMinutes}分钟", Icons.timer, AppColors.primary),
      const SizedBox(width: 12),
      _miniStat(t, "冥想次数", "${h.totalSessions}次", Icons.self_improvement, const Color(0xFF52B788)),
      const SizedBox(width: 12),
      _miniStat(t, "连续天数", "${h.streakDays}天", Icons.local_fire_department, AppColors.accent),
    ].map((w) => Expanded(child: w)).toList());
  }

  Widget _miniStat(ThemeData t, String label, String value, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRouter.profile),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: t.cardColor,
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          Text(label, style: t.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ]),
      ),
    );
  }

  Widget _quickStart(BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(ctx, AppRouter.breathing),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(colors: AppColors.gradientBreathing),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: const Column(children: [
          Icon(Icons.air, color: Colors.white, size: 36),
          SizedBox(height: 8),
          Text("5分钟快速呼吸", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _dailyCard(BuildContext ctx, Meditation m, ThemeData t) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("今日推荐", style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      MeditationCard(meditation: m, onTap: () => Navigator.pushNamed(ctx, AppRouter.meditationPlayer, arguments: m)),
    ]);
  }

  Widget _categories(BuildContext ctx, ThemeData t) {
    final cats = [
      {"icon": Icons.wb_sunny, "label": "晨间", "cat": "morning"},
      {"icon": Icons.spa, "label": "减压", "cat": "stress"},
      {"icon": Icons.center_focus_strong, "label": "专注", "cat": "focus"},
      {"icon": Icons.nightlight_round, "label": "睡眠", "cat": "sleep"},
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("探索", style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: cats.map((c) => GestureDetector(
        onTap: () => Navigator.pushNamed(ctx, AppRouter.meditationList, arguments: c["cat"]),
        child: Column(children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: t.cardColor), child: Icon(c["icon"] as IconData, color: AppColors.primary, size: 28)),
          const SizedBox(height: 8),
          Text(c["label"] as String, style: t.textTheme.bodySmall),
        ]),
      )).toList()),
    ]);
  }

  Widget _bottomNav(BuildContext ctx) {
    return BottomNavigationBar(currentIndex: 0, onTap: (idx) {
      if (idx == 1) Navigator.pushNamed(ctx, AppRouter.meditationList);
      if (idx == 2) Navigator.pushNamed(ctx, AppRouter.sleep);
      if (idx == 3) Navigator.pushNamed(ctx, AppRouter.profile);
    }, items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "首页"),
      BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: "冥想"),
      BottomNavigationBarItem(icon: Icon(Icons.nightlight_round), label: "睡眠"),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "我的"),
    ]);
  }
}