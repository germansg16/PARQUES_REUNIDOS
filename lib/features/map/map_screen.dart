import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/map_provider.dart';
import '../../data/models/eco_station_model.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  static const _center = LatLng(40.4180, -3.7030);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(stationsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.navBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColors.neonGreen, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        AppConstants.parkName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.neonGreenGlow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '5 estaciones',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neonGreen,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
            const SizedBox(height: 12),

            // ── Map ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: _center,
                      initialZoom: 16.5,
                      minZoom: 14,
                      maxZoom: 19,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.ecoguardianes.app',
                      ),
                      MarkerLayer(
                        markers: stations
                            .map((s) => _buildMarker(context, s))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
            const SizedBox(height: 12),

            // ── Legend ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(
                    color: AppColors.neonGreen,
                    label: 'Eco-Estación',
                  ),
                  const SizedBox(width: 20),
                  _LegendItem(
                    color: AppColors.accentYellow,
                    label: 'x2 Puntos',
                  ),
                  const SizedBox(width: 20),
                  _LegendItem(
                    color: AppColors.accentRed,
                    label: 'Saturada',
                  ),
                ],
              ),
            ).animate(delay: 400.ms).fadeIn(),
          ],
        ),
      ),
    );
  }

  Marker _buildMarker(BuildContext context, EcoStationModel station) {
    final color = station.isSaturated
        ? AppColors.accentRed
        : station.isDoublePoints
            ? AppColors.accentYellow
            : AppColors.neonGreen;

    return Marker(
      point: station.position,
      width: station.isDoublePoints ? 90 : 52,
      height: station.isDoublePoints ? 52 : 52,
      child: GestureDetector(
        onTap: () => _showStationInfo(context, station),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(
                    station.isDoublePoints ? 20 : 50),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.recycling_rounded,
                      color: AppColors.bgDark, size: 18),
                  if (station.isDoublePoints) ...[
                    const SizedBox(width: 4),
                    const Text(
                      'x2 Puntos',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.bgDark,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStationInfo(BuildContext context, EcoStationModel station) {
    final color = station.isSaturated
        ? AppColors.accentRed
        : station.isDoublePoints
            ? AppColors.accentYellow
            : AppColors.neonGreen;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.recycling_rounded, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      Text(
                        station.zone,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (station.isDoublePoints)
              _InfoChip(
                icon: Icons.bolt,
                label: '¡Puntos x2 activos!',
                color: AppColors.accentYellow,
              ),
            if (station.isSaturated)
              _InfoChip(
                icon: Icons.warning_amber_rounded,
                label: 'Estación saturada — ve a otra',
                color: AppColors.accentRed,
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
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
