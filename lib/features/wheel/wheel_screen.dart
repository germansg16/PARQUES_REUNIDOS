import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math';
import '../../core/theme/app_colors.dart';
import '../../data/providers/wheel_provider.dart';
import '../../data/providers/user_provider.dart';
import '../../data/providers/wallet_provider.dart';
import '../../data/repositories/mock_repository.dart';
import '../../data/models/reward_model.dart';
import 'package:uuid/uuid.dart';

class WheelScreen extends ConsumerStatefulWidget {
  const WheelScreen({super.key});

  @override
  ConsumerState<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends ConsumerState<WheelScreen>
    with TickerProviderStateMixin {
  final _selected = StreamController<int>.broadcast();
  final _segments = MockRepository.getWheelSegments();
  bool _isSpinning = false;
  int? _wonIndex;
  late AnimationController _confettiController;

  static const _segmentColors = [
    AppColors.wheelRed,
    AppColors.wheelYellow,
    AppColors.wheelOrange,
    AppColors.wheelGreen,
    AppColors.wheelBlue,
    AppColors.wheelPurple,
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _selected.close();
    _confettiController.dispose();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning) return;
    HapticFeedback.heavyImpact();
    final rnd = Random().nextInt(_segments.length);
    setState(() {
      _isSpinning = true;
      _wonIndex = null;
    });
    _selected.add(rnd);

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      setState(() {
        _isSpinning = false;
        _wonIndex = rnd;
      });
      _confettiController.forward(from: 0);

      final segment = _segments[rnd];
      if (segment.rewardType != RewardType.points &&
          segment.rewardType != RewardType.discount) {
        final reward = RewardModel(
          id: const Uuid().v4(),
          title: segment.rewardTitle,
          subtitle: segment.rewardSubtitle,
          type: segment.rewardType,
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
          barcodeData: 'ECP-${DateTime.now().millisecondsSinceEpoch}',
        );
        ref.read(walletProvider.notifier).addReward(reward);
        ref.read(userProvider.notifier).addPrize();
      } else {
        ref.read(userProvider.notifier).addExp(30);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showOverlay = ref.watch(scanSuccessOverlayProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            _buildWheelContent(context),
            if (showOverlay) _buildSuccessOverlay(context),
            if (_wonIndex != null)
              IgnorePointer(
                child: _ConfettiLayer(controller: _confettiController),
              ),
            if (_wonIndex != null && !_isSpinning)
              _buildPrizeModal(context, _wonIndex!),
          ],
        ),
      ),
    );
  }

  Widget _buildWheelContent(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Ruleta',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontFamily: 'Outfit',
          ),
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 8),
        const Text(
          'Gira y gana un premio increíble',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontFamily: 'Outfit',
          ),
        ).animate(delay: 200.ms).fadeIn(),
        const SizedBox(height: 32),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FortuneWheel(
              selected: _selected.stream,
              animateFirst: false,
              duration: const Duration(seconds: 5),
              physics: CircularPanPhysics(
                duration: const Duration(seconds: 5),
                curve: Curves.decelerate,
              ),
              onFling: _spin,
              items: List.generate(_segments.length, (i) {
                final seg = _segments[i];
                return FortuneItem(
                  style: FortuneItemStyle(
                    color: _segmentColors[i % _segmentColors.length],
                    borderColor: AppColors.bgDark,
                    borderWidth: 3,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: 'Outfit',
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  child: Text(seg.label, textAlign: TextAlign.center),
                );
              }),
              indicators: const [
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: TriangleIndicator(
                    color: AppColors.neonGreen,
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ).animate(delay: 300.ms).scale(
              begin: const Offset(0.85, 0.85),
              curve: Curves.easeOutBack,
              duration: 700.ms,
            ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _spin,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _isSpinning
                    ? [AppColors.bgCardLight, AppColors.bgCard]
                    : [AppColors.neonGreen, AppColors.neonGreenDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: _isSpinning
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.neonGreen.withValues(alpha: 0.5),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
            ),
            child: Center(
              child: Text(
                _isSpinning ? '...' : 'GIRAR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color:
                      _isSpinning ? AppColors.textSecondary : AppColors.bgDark,
                  fontFamily: 'Outfit',
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ).animate(delay: 400.ms).fadeIn().scale(
              begin: const Offset(0.8, 0.8),
              curve: Curves.elasticOut,
              duration: 800.ms,
            ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSuccessOverlay(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          ref.read(scanSuccessOverlayProvider.notifier).state = false;
        },
        child: Container(
          color: AppColors.bgDark.withValues(alpha: 0.92),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.neonGreen,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGreen.withValues(alpha: 0.3),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.neonGreen,
                  size: 44,
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.3, 0.3),
                    curve: Curves.elasticOut,
                    duration: 700.ms,
                  )
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: 24),
              const Text(
                '¡Bandeja Reciclada!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.neonGreen,
                  fontFamily: 'Outfit',
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.15),
              const SizedBox(height: 8),
              const Text(
                'Has desbloqueado una tirada.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontFamily: 'Outfit',
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: 40),
              Text(
                'Toca para girar la ruleta',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontFamily: 'Outfit',
                ),
              ).animate(delay: 800.ms).fadeIn().then().shimmer(
                    duration: 2000.ms,
                    color: AppColors.neonGreen.withValues(alpha: 0.4),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrizeModal(BuildContext context, int index) {
    final segment = _segments[index];
    final color = _segmentColors[index % _segmentColors.length];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 32,
              spreadRadius: 4,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.navBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border:
                    Border.all(color: color.withValues(alpha: 0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(Icons.card_giftcard_rounded, color: color, size: 34),
            )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  curve: Curves.elasticOut,
                  duration: 800.ms,
                )
                .fadeIn(duration: 300.ms),
            const SizedBox(height: 16),
            Text(
              '🎉 ¡${segment.rewardTitle}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontFamily: 'Outfit',
              ),
              textAlign: TextAlign.center,
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 6),
            Text(
              segment.rewardSubtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontFamily: 'Outfit',
              ),
            ).animate(delay: 350.ms).fadeIn(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _wonIndex = null);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGreen,
                      foregroundColor: AppColors.bgDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ver mi Mochila 🎒',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.15),
          ],
        ),
      ).animate().slideY(
            begin: 0.5,
            curve: Curves.easeOutCubic,
            duration: 500.ms,
          ),
    );
  }
}

class _ConfettiLayer extends StatelessWidget {
  final AnimationController controller;
  const _ConfettiLayer({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const colors = [
      AppColors.neonGreen,
      AppColors.accentYellow,
      AppColors.accentPink,
      AppColors.accentBlue,
      AppColors.wheelOrange,
      AppColors.wheelPurple,
    ];
    final rnd = Random(42);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        return Stack(
          children: List.generate(60, (i) {
            final startX = rnd.nextDouble() * size.width;
            final speedX = (rnd.nextDouble() - 0.5) * 200;
            final speedY = rnd.nextDouble() * size.height * 0.8 + 100;
            final color = colors[i % colors.length];
            final x = startX + speedX * t;
            final y = -30 + speedY * t;
            final opacity = (1 - t).clamp(0.0, 1.0);
            final rotate = rnd.nextDouble() * 4 * pi * t;

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: opacity,
                child: Transform.rotate(
                  angle: rotate,
                  child: Container(
                    width: rnd.nextDouble() * 8 + 6,
                    height: rnd.nextDouble() * 8 + 6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius:
                          BorderRadius.circular(rnd.nextBool() ? 50 : 2),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
