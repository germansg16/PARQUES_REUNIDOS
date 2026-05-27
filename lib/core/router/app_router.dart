import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/park_selection/park_selection_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/scanner/scanner_screen.dart';
import '../../features/wheel/wheel_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../shared/widgets/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/park-select',
      builder: (context, state) => const ParkSelectionScreen(),
    ),
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
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
  ],
);
