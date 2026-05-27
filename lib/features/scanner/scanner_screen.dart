import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/user_provider.dart';
import '../../data/providers/wheel_provider.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with TickerProviderStateMixin {
  MobileScannerController? _controller;
  bool _hasScanned = false;
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  void _onScanSuccess(String qrData) {
    if (_hasScanned) return;
    _hasScanned = true;
    HapticFeedback.heavyImpact();
    _controller?.stop();

    ref.read(userProvider.notifier).addRecycle();

    ref.read(scanSuccessOverlayProvider.notifier).state = true;

    context.pushReplacement('/wheel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue != null) {
                _onScanSuccess(barcode!.rawValue!);
              }
            },
          ),
          CustomPaint(
            painter: _ScanOverlayPainter(),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            child: AnimatedBuilder(
              animation: _scanLineController,
              builder: (_, __) => Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.neonGreen,
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGreen.withValues(alpha: 0.8),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Escaner',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Escanea el QR\nen la papelera',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.3,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    const Text(
                      '📍 Alinea el codigo dentro del marco',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => _onScanSuccess('ECO-STATION-007-X2'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.neonGreen,
                        side: const BorderSide(color: AppColors.neonGreen),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '[ Simular Escaneo Exitoso ]',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .slideY(begin: 0.2),
          ),
        ],
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    const cutoutSize = 240.0;
    final left = (size.width - cutoutSize) / 2;
    final top = size.height * 0.28;
    final cutout = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, cutoutSize, cutoutSize),
      const Radius.circular(16),
    );

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(cutout)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    final bracketPaint = Paint()
      ..color = AppColors.neonGreen
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const bLen = 28.0;
    final corners = [
      [Offset(left, top), Offset(left + bLen, top), Offset(left, top + bLen)],
      [
        Offset(left + cutoutSize, top),
        Offset(left + cutoutSize - bLen, top),
        Offset(left + cutoutSize, top + bLen)
      ],
      [
        Offset(left, top + cutoutSize),
        Offset(left + bLen, top + cutoutSize),
        Offset(left, top + cutoutSize - bLen)
      ],
      [
        Offset(left + cutoutSize, top + cutoutSize),
        Offset(left + cutoutSize - bLen, top + cutoutSize),
        Offset(left + cutoutSize, top + cutoutSize - bLen)
      ],
    ];

    for (final corner in corners) {
      final p = Path()
        ..moveTo(corner[1].dx, corner[1].dy)
        ..lineTo(corner[0].dx, corner[0].dy)
        ..lineTo(corner[2].dx, corner[2].dy);
      canvas.drawPath(p, bracketPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
