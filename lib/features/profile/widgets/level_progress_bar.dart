import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LevelProgressBar extends StatelessWidget {
  final int level;
  final int currentExp;
  final int maxExp;

  const LevelProgressBar({
    super.key,
    required this.level,
    required this.currentExp,
    required this.maxExp,
  });

  @override
  Widget build(BuildContext context) {
    final targetProgress = currentExp / maxExp;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nvl $level',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                fontFamily: 'Outfit',
              ),
            ),
            Text(
              '$currentExp/$maxExp EXP',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                fontFamily: 'Outfit',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.bgCardLight,
              borderRadius: BorderRadius.circular(50),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: targetProgress),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return Stack(
                      children: [
                        Container(
                          width: constraints.maxWidth * value,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.accentBlue,
                                AppColors.neonGreen,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonGreen
                                    .withValues(alpha: 0.5 * value),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
