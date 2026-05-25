import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/wallet_provider.dart';
import '../../data/models/reward_model.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mi Mochila',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rewards.where((r) => r.isValid).length} premios activos',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 16),

            // ── Rewards list ──
            Expanded(
              child: rewards.isEmpty
                  ? _EmptyWallet()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: rewards.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        return RewardCard(
                          reward: rewards[i],
                          animDelay: i * 120,
                          onUse: () => ref
                              .read(walletProvider.notifier)
                              .markAsUsed(rewards[i].id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final RewardModel reward;
  final int animDelay;
  final VoidCallback? onUse;

  const RewardCard({
    super.key,
    required this.reward,
    this.animDelay = 0,
    this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    final isUsed = reward.isUsed;
    final accent = reward.accentColor;

    return Container(
      decoration: BoxDecoration(
        color: isUsed ? AppColors.bgCard.withValues(alpha: 0.5) : AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUsed
              ? AppColors.navBorder
              : accent.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: isUsed
            ? []
            : [
                BoxShadow(
                  color: accent.withValues(alpha: 0.08),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
      ),
      child: Column(
        children: [
          // ── Top row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isUsed
                        ? AppColors.bgCardLight
                        : accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    reward.icon,
                    color: isUsed ? AppColors.textMuted : accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isUsed
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          fontFamily: 'Outfit',
                          decoration: isUsed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Text(
                        reward.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isUsed ? AppColors.textMuted : accent,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isUsed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: accent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      reward.expiryLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: accent,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Divider ──
          Divider(
            height: 1,
            color: isUsed
                ? AppColors.navBorder.withValues(alpha: 0.3)
                : AppColors.navBorder,
          ),

          // ── Barcode ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (isUsed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Ya utilizado.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                Opacity(
                  opacity: isUsed ? 0.3 : 1.0,
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: reward.barcodeData,
                    width: double.infinity,
                    height: 60,
                    color: isUsed ? AppColors.textMuted : AppColors.textPrimary,
                    backgroundColor: Colors.transparent,
                    drawText: false,
                  ),
                ),
                if (!isUsed) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Enséñale este código al camarero.',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontFamily: 'Outfit',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID:${reward.barcodeData}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontFamily: 'Courier',
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onUse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      child: const Text('Marcar como usado'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: animDelay))
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.1, curve: Curves.easeOutCubic);
  }
}

class _EmptyWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎒', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'Tu mochila está vacía',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Escanea el QR de una papelera\npara ganar tu primer premio',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontFamily: 'Outfit',
              height: 1.5,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(
            begin: const Offset(0.9, 0.9),
            curve: Curves.easeOutBack,
          ),
    );
  }
}
