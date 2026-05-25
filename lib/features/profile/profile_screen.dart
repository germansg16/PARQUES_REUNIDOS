import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/user_provider.dart';
import '../../data/providers/map_provider.dart';
import 'widgets/level_progress_bar.dart';
import 'widgets/stats_card.dart';
import 'widgets/mission_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final mission = ref.watch(dailyMissionProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tu Perfil',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.navBorder),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 24),

              // ── Profile Card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.navBorder),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.neonGreen,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonGreen.withValues(alpha: 0.3),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Container(
                              color: AppColors.bgCardLight,
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.accentYellow,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.bgCard,
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '🥉',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.7, 0.7),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFamily: 'Outfit',
                      ),
                    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
                    const SizedBox(height: 4),
                    Text(
                      user.levelTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neonGreen,
                        fontFamily: 'Outfit',
                      ),
                    ).animate(delay: 300.ms).fadeIn(),
                    const SizedBox(height: 20),
                    LevelProgressBar(
                      level: user.level,
                      currentExp: user.currentExp,
                      maxExp: user.maxExp,
                    ),
                    const SizedBox(height: 20),
                    // Stats
                    Row(
                      children: [
                        StatsCard(
                          icon: Icons.recycling_rounded,
                          value: '${user.recycleCount}',
                          label: 'Reciclajes',
                          animDelay: 400,
                        ),
                        const SizedBox(width: 12),
                        StatsCard(
                          icon: Icons.card_giftcard_rounded,
                          value: '${user.prizeCount}',
                          label: 'Premios',
                          iconColor: AppColors.accentYellow,
                          animDelay: 550,
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: 100.ms).fadeIn(duration: 600.ms).slideY(
                    begin: 0.05,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 20),

              // ── Impact Stats ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.navBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ImpactStat(
                      emoji: '🌱',
                      value: '${user.co2Saved.toStringAsFixed(1)} kg',
                      label: 'CO₂ Ahorrado',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.navBorder,
                    ),
                    _ImpactStat(
                      emoji: '♻️',
                      value: '${user.recycleCount * 3}',
                      label: 'Items reciclados',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.navBorder,
                    ),
                    _ImpactStat(
                      emoji: '🏆',
                      value: 'Nvl ${user.level}',
                      label: 'Eco-Héroe',
                    ),
                  ],
                ),
              )
                  .animate(delay: 350.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.08, curve: Curves.easeOutCubic),
              const SizedBox(height: 20),

              // ── Mission Card ──
              MissionCard(mission: mission),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _ImpactStat({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontFamily: 'Outfit',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }
}
