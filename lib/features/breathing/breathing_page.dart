import "dart:math";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../core/theme/app_colors.dart";
import "../../shared/models/breathing_pattern.dart";
import "providers/breathing_provider.dart";

class BreathingPage extends StatelessWidget {
  const BreathingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = context.watch<BreathingProvider>();
    final p = bp.pattern;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("呼吸训练")),
      body: SafeArea(
        child: p == null ? _patternSelector(context) : _breathingSession(context, bp, p, theme),
      ),
    );
  }

  Widget _patternSelector(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: BreathingLibrary.patterns.map((p) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primary.withValues(alpha: 0.1)),
              child: const Icon(Icons.air, color: AppColors.primary),
            ),
            title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(p.description, style: const TextStyle(fontSize: 13)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.read<BreathingProvider>().selectPattern(p);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _breathingSession(BuildContext context, BreathingProvider bp, BreathingPattern p, ThemeData theme) {
    final animSize = bp.isRunning ? 120.0 + sin(bp.phaseSecondsLeft * 0.5) * 40 : 120.0;
    
    return Column(
      children: [
        const Spacer(flex: 2),
        // Animated circle
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: animSize, height: animSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: AppColors.gradientBreathing),
            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: 5)],
          ),
        ),
        const SizedBox(height: 40),
        Text(bp.phaseLabel, style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
        if (bp.isRunning) ...[
          const SizedBox(height: 8),
          Text("${bp.phaseSecondsLeft}s", style: theme.textTheme.titleLarge?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text("第 ${bp.currentCycle} / ${p.cycles} 轮", style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ],
        const Spacer(flex: 2),
        _breathingControls(bp, theme),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _breathingControls(BreathingProvider bp, ThemeData theme) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (bp.isRunning)
        ElevatedButton.icon(
          onPressed: bp.stop,
          icon: const Icon(Icons.stop),
          label: const Text("结束"),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
        )
      else
        ElevatedButton.icon(
          onPressed: bp.pattern != null ? bp.start : null,
          icon: const Icon(Icons.play_arrow),
          label: const Text("开始训练"),
        ),
      const SizedBox(width: 16),
      OutlinedButton.icon(
        onPressed: bp.reset,
        icon: const Icon(Icons.refresh),
        label: const Text("重置"),
      ),
    ]);
  }
}
