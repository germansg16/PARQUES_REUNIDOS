import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/park_model.dart';
import '../../data/providers/park_provider.dart';

class ParkSelectionScreen extends ConsumerStatefulWidget {
  const ParkSelectionScreen({super.key});

  @override
  ConsumerState<ParkSelectionScreen> createState() =>
      _ParkSelectionScreenState();
}

class _ParkSelectionScreenState extends ConsumerState<ParkSelectionScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _countryFilter = 'Todos';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ParkModel> get _filtered {
    final q = _query.toLowerCase();
    return ParkCatalogue.all.where((p) {
      final matchName = p.name.toLowerCase().contains(q) ||
          p.country.toLowerCase().contains(q);
      final matchCountry =
          _countryFilter == 'Todos' || p.country.contains(_countryFilter);
      return matchName && matchCountry;
    }).toList();
  }

  List<String> get _countries {
    final set = <String>{'Todos'};
    for (final p in ParkCatalogue.all) {
      final parts = p.country.split(',');
      if (parts.length >= 2) {
        set.add(parts.last.trim());
      }
    }
    return set.toList();
  }

  void _selectPark(ParkModel park) {
    ref.read(selectedParkProvider.notifier).state = park;
    context.go('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final parks = _filtered;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.neonGreen.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.bgCard,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.navBorder),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.neonGreenGlow,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.neonGreen
                                      .withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.eco_rounded,
                                    size: 14, color: AppColors.neonGreen),
                                const SizedBox(width: 6),
                                const Text(
                                  'Parques Reunidos',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.neonGreen,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '¿A qué parque\nvas hoy?',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          fontFamily: 'Outfit',
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                      const SizedBox(height: 6),
                      const Text(
                        'Selecciona tu parque y empieza a reciclar',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontFamily: 'Outfit',
                        ),
                      ).animate(delay: 150.ms).fadeIn(),
                      const SizedBox(height: 20),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.navBorder),
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _query = v),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Outfit',
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Buscar parque o país...',
                            hintStyle: TextStyle(
                              color: AppColors.textMuted,
                              fontFamily: 'Outfit',
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: AppColors.textSecondary, size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.08),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 34,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _countries.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final c = _countries[i];
                            final isActive = _countryFilter == c;
                            return GestureDetector(
                              onTap: () => setState(() => _countryFilter = c),
                              child: AnimatedContainer(
                                duration: 200.ms,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.neonGreen
                                      : AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isActive
                                        ? AppColors.neonGreen
                                        : AppColors.navBorder,
                                  ),
                                ),
                                child: Text(
                                  c,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? AppColors.bgDark
                                        : AppColors.textSecondary,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ).animate(delay: 350.ms).fadeIn(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: parks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🔍', style: TextStyle(fontSize: 48)),
                              const SizedBox(height: 12),
                              Text(
                                'No se encontró "$_query"',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                          itemCount: parks.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) => _ParkCard(
                            park: parks[i],
                            animDelay: i * 80,
                            onTap: () => _selectPark(parks[i]),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkCard extends StatelessWidget {
  final ParkModel park;
  final int animDelay;
  final VoidCallback onTap;

  const _ParkCard({
    required this.park,
    required this.animDelay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: park.accentColor.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: park.accentColor.withValues(alpha: 0.06),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: park.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: park.accentColor.withValues(alpha: 0.25)),
              ),
              child: Center(
                child: Text(
                  park.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    park.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontFamily: 'Outfit',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    park.country,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatPill(
                        icon: Icons.recycling_rounded,
                        label: '${park.stations.length} eco-estaciones',
                        color: park.accentColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: park.accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: park.accentColor,
              ),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: animDelay))
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.06, curve: Curves.easeOutCubic),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }
}
