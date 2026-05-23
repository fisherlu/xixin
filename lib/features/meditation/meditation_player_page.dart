import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/meditation.dart';
import 'providers/meditation_provider.dart';

class MeditationPlayerPage extends StatefulWidget {
  const MeditationPlayerPage({super.key});
  @override State<MeditationPlayerPage> createState() => _MeditationPlayerPageState();
}

class _MeditationPlayerPageState extends State<MeditationPlayerPage> {
  String _scriptText = '';
  bool _showScript = false;

  @override Widget build(BuildContext context) {
    final p = context.watch<MeditationProvider>();
    final m = p.current;
    if (m == null) return const SizedBox();
    final theme = Theme.of(context);
    final progress = p.durationSeconds > 0 ? p.progress / p.durationSeconds : 0.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: AppColors.gradientEvening),
        ),
        child: SafeArea(child: Column(children: [
          _appBar(context),
          Expanded(
            child: _showScript && _scriptText.isNotEmpty
                ? _scriptView(theme)
                : _playerView(theme, m, p, progress),
          ),
        ])),
      ),
    );
  }

  Widget _playerView(ThemeData theme, Meditation m, MeditationProvider p, double progress) {
    return Column(children: [
      const Spacer(),
      _titleSection(theme, m),
      const SizedBox(height: 48),
      _progressSection(theme, p, progress),
      const SizedBox(height: 48),
      _controls(theme, p),
      const SizedBox(height: 24),
      _ambientSelector(theme, p),
      const SizedBox(height: 16),
      _scriptToggle(theme),
      const Spacer(),
    ]);
  }

  Widget _scriptView(ThemeData theme) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          _scriptToggle(theme),
          const Spacer(),
        ]),
      ),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Text(
            _scriptText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              height: 1.8,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _scriptToggle(ThemeData theme) {
    return TextButton.icon(
      onPressed: () async {
        if (!_showScript) {
          await _loadScript();
        }
        setState(() => _showScript = !_showScript);
      },
      icon: Icon(_showScript ? Icons.headphones : Icons.article, color: Colors.white54, size: 18),
      label: Text(
        _showScript ? '返回播放' : '查看引导词',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
      ),
    );
  }

  Future<void> _loadScript() async {
    final m = context.read<MeditationProvider>().current;
    if (m?.scriptAsset == null) return;
    try {
      _scriptText = await DefaultAssetBundle.of(context).loadString(m!.scriptAsset!);
      setState(() {});
    } catch (_) {
      _scriptText = '(暂无引导词)';
      setState(() {});
    }
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () {
            context.read<MeditationProvider>().stop();
            Navigator.pop(context);
          },
        ),
        const Text('正念冥想', style: TextStyle(color: Colors.white54, fontSize: 13)),
        const SizedBox(width: 48),
      ]),
    );
  }

  Widget _titleSection(ThemeData theme, Meditation m) {
    return Column(children: [
      Text(m.title, style: theme.textTheme.headlineMedium?.copyWith(
        color: Colors.white, fontWeight: FontWeight.w600,
      )),
      const SizedBox(height: 8),
      Text(m.narrator ?? '林静', style: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.white60,
      )),
    ]);
  }

  Widget _progressSection(ThemeData theme, MeditationProvider p, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress, minHeight: 4,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        Text(' 分钟', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54)),
      ]),
    );
  }

  Widget _controls(ThemeData theme, MeditationProvider p) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(width: 48),
      IconButton(icon: const Icon(Icons.replay_10, color: Colors.white70, size: 32), onPressed: () {}),
      const SizedBox(width: 32),
      GestureDetector(
        onTap: p.pauseResume,
        child: Container(
          width: 72, height: 72,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Icon(p.isPaused ? Icons.play_arrow : Icons.pause, size: 36, color: AppColors.primary),
        ),
      ),
      const SizedBox(width: 32),
      IconButton(icon: const Icon(Icons.forward_10, color: Colors.white70, size: 32), onPressed: () {}),
      const SizedBox(width: 48),
    ]);
  }

  Widget _ambientSelector(ThemeData theme, MeditationProvider p) {
    final ambients = [
      {'id': 'rain', 'label': '雨声', 'asset': 'assets/audio/ambient/rain.mp3'},
      {'id': 'forest', 'label': '森林', 'asset': 'assets/audio/ambient/forest.mp3'},
      {'id': 'wave', 'label': '浪潮', 'asset': 'assets/audio/ambient/wave.mp3'},
      {'id': 'none', 'label': '无', 'asset': ''},
    ];
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: ambients.map((a) {
      final sel = p.ambientId == a['id'];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: GestureDetector(
          onTap: () => a['id'] == 'none' ? p.clearAmbient() : p.setAmbient(a['id']!, a['asset']!),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: sel ? Colors.white24 : Colors.white12,
            ),
            child: Text(a['label']!, style: TextStyle(
              color: sel ? Colors.white : Colors.white54, fontSize: 13,
            )),
          ),
        ),
      );
    }).toList());
  }
}