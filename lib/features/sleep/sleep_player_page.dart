import "package:flutter/material.dart";
import "../../core/theme/app_colors.dart";
import "../../shared/models/sleep_story.dart";

class SleepPlayerPage extends StatefulWidget {
  const SleepPlayerPage({super.key});
  @override State<SleepPlayerPage> createState() => _SleepPlayerPageState();
}

class _SleepPlayerPageState extends State<SleepPlayerPage> {
  bool _isPlaying = false;
  int _timerMinutes = 30;

  @override Widget build(BuildContext context) {
    final story = ModalRoute.of(context)?.settings.arguments as SleepStory?;
    if (story == null) return const SizedBox();
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: AppColors.gradientSleep)),
        child: SafeArea(child: Column(children: [
          const SizedBox(height: 60),
          const Icon(Icons.nightlight_round, size: 64, color: Colors.white38),
          const SizedBox(height: 32),
          Text(story.title, style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(story.description, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white60), textAlign: TextAlign.center),
          const Spacer(),
          _timerSelector(theme),
          const SizedBox(height: 48),
          _playButton(theme),
          const SizedBox(height: 48),
        ])),
      ),
    );
  }

  Widget _timerSelector(ThemeData theme) {
    final opts = [15, 30, 45, 60, 90];
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.timer, color: Colors.white54, size: 18),
      const SizedBox(width: 8),
      ...opts.map((t) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: () => setState(() => _timerMinutes = t),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _timerMinutes == t ? Colors.white24 : Colors.white10,
            ),
            child: Text("${t}min", style: TextStyle(color: _timerMinutes == t ? Colors.white : Colors.white54, fontSize: 13)),
          ),
        ),
      )),
    ]);
  }

  Widget _playButton(ThemeData theme) {
    return GestureDetector(
      onTap: () => setState(() => _isPlaying = !_isPlaying),
      child: Container(
        width: 80, height: 80,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 40, color: AppColors.primaryDark),
      ),
    );
  }
}
