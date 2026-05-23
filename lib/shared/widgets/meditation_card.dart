import "package:flutter/material.dart";
import "../../core/theme/app_colors.dart";
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
      onTap: onTap,
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
                  Text(
                    meditation.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meditation.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
