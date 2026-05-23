import "package:flutter/material.dart";
import "../../core/theme/app_colors.dart";

class OnboardingPage extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingPage({super.key, required this.onComplete});

  @override State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingData(
      icon: Icons.self_improvement,
      title: "欢迎来到息心",
      description: "你的中文原生正念冥想伴侣\n用古老的智慧，安抚现代的心",
      color: AppColors.primary,
    ),
    _OnboardingData(
      icon: Icons.air,
      title: "科学呼吸训练",
      description: "箱式呼吸、4-7-8呼吸法、Wim Hof\n多种呼吸模式，帮你调节身心状态",
      color: AppColors.accent,
    ),
    _OnboardingData(
      icon: Icons.nightlight_round,
      title: "安睡故事与白噪音",
      description: "温暖的睡前故事，轻柔的环境音\n让每一个夜晚都安宁入梦",
      color: AppColors.primaryDark,
    ),
  ];

  @override void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: widget.onComplete,
              child: Text(
                _currentPage == _pages.length - 1 ? "开始" : "跳过",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (_, i) => _buildPage(_pages[i]),
            ),
          ),
          _buildIndicator(),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [data.color.withValues(alpha: 0.3), data.color.withValues(alpha: 0.1)],
            ),
          ),
          child: Icon(data.icon, size: 56, color: data.color),
        ),
        const SizedBox(height: 48),
        Text(data.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Text(data.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary, height: 1.6), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _buildIndicator() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_pages.length, (i) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: _currentPage == i ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: _currentPage == i ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
        ),
      );
    }));
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  const _OnboardingData({required this.icon, required this.title, required this.description, required this.color});
}