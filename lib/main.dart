import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

// Dimensiones objetivo: iPhone 14
const double kMobileWidth = 390.0;
const double kMobileHeight = 844.0;

void main() {
  runApp(
    const ProviderScope(
      child: EcoGuardianesApp(),
    ),
  );
}

class EcoGuardianesApp extends StatelessWidget {
  const EcoGuardianesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Eco-Guardianes del Parque',
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => MobileFrame(child: child ?? const SizedBox.shrink()),
    );
  }
}

/// Wrapper que en pantallas grandes (web/desktop/tablet) muestra la app
/// centrada con la resolución de un iPhone 14 (390×844).
/// En móvil real ocupa toda la pantalla de forma nativa.
class MobileFrame extends StatelessWidget {
  final Widget child;
  const MobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600 || screenSize.height > 900;

    if (!isLargeScreen) {
      // Móvil real → pantalla completa, sin restricciones
      return child;
    }

    // Web / Desktop / Tablet → simular iPhone 14
    return Container(
      color: const Color(0xFF050709), // fondo oscuro alrededor del frame
      child: Center(
        child: SizedBox(
          width: kMobileWidth,
          height: kMobileHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(44),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                  BoxShadow(
                    color: const Color(0xFF00E676).withValues(alpha: 0.08),
                    blurRadius: 80,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: MediaQuery(
                // Forzar las métricas exactas del iPhone 14
                data: MediaQuery.of(context).copyWith(
                  size: const Size(kMobileWidth, kMobileHeight),
                  devicePixelRatio: 3.0,
                  padding: const EdgeInsets.only(top: 47, bottom: 34),
                  viewPadding: const EdgeInsets.only(top: 47, bottom: 34),
                  viewInsets: EdgeInsets.zero,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
