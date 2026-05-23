import "package:flutter/material.dart";
import "../../core/theme/app_colors.dart";
import "../../core/storage/hive_service.dart";
import "../../core/router/app_router.dart";
import "../models/meditation.dart";

class MeditationCard extends StatelessWidget {
  final Meditation meditation;
  final VoidCallback onTap;

  const MeditationCard({
    super.key,
    required this.meditation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (meditation.isPremium && !HiveService.isPremium) {
          _showPremiumDialog(context);
          return;
        }
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: AppColors.gradientBreathing,
                ),
              ),
              child: Icon(
                _categoryIcon(meditation.category),
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                        meditation.title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (meditation.isPremium)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.accent.withValues(alpha: 0.15),
                        ),
                        child: const Text('会员', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                  ]),
                  const SizedBox(height: 4),
                  Text(
                    meditation.description,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Text(
                  meditation.durationText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (meditation.isPremium)
                  const Icon(Icons.star, size: 16, color: AppColors.accent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.lock, color: AppColors.accent),
          SizedBox(width: 8),
          Text('会员专属'),
        ]),
        content: Text('「${meditation.title}」是高级会员内容。\n\n升级会员即可畅享全部冥想课程与睡眠故事。'),
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

  IconData _categoryIcon(MeditationCategory cat) {
    switch (cat) {
      case MeditationCategory.morning:
        return Icons.wb_sunny;
      case MeditationCategory.sleep:
        return Icons.nightlight_round;
      case MeditationCategory.focus:
        return Icons.center_focus_strong;
      case MeditationCategory.stress:
        return Icons.spa;
      case MeditationCategory.compassion:
        return Icons.favorite;
      case MeditationCategory.body:
        return Icons.accessibility_new;
    }
  }
}