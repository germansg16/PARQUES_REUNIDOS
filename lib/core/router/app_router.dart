import 'package:go_router/go_router.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/scanner/scanner_screen.dart';
import '../../features/wheel/wheel_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../shared/widgets/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/profile',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MapScreen(),
          ),
        ),
        GoRoute(
          path: '/wallet',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WalletScreen(),
          ),
        ),
        GoRoute(
          path: '/wheel',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WheelScreen(),
          ),
        ),
      ],
    ),
    // Scanner is full-screen modal — outside shell
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
  ],
);
