import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/map_provider.dart';
import '../../data/providers/park_provider.dart';
import '../../data/models/eco_station_model.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  // Fallback center when no park is selected (Madrid)
  static const _fallbackCenter = LatLng(40.4100, -3.7484);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final park = ref.watch(selectedParkProvider);
    final List<EcoStationModel> stations =
        park?.stations ?? ref.watch(stationsProvider);

    final center = park?.center ?? _fallbackCenter;
    final initialZoom = park?.initialZoom ?? 16.5;
    final minZoom = park?.minZoom ?? 15.5;
    final bounds = park?.bounds;
    final polygon = park?.polygon;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.navBorder),
                      ),
                      child: Row(
                        children: [
                          // Pulsing green dot
                          _PulsingDot(),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              park?.name ?? 'Selecciona un parque',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Outfit',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.neonGreenGlow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${stations.length} eco-est.',
                              style: const TextStyle(
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
                  ),
                  const SizedBox(width: 10),
                  // Change park button
                  GestureDetector(
                    onTap: () => context.go('/park-select'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.navBorder),
                      ),
                      child: const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
            const SizedBox(height: 12),

            // ── Map ──────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: initialZoom,
                      minZoom: minZoom,
                      maxZoom: 19,
                      // ── Camera constraint: equivalent to Leaflet maxBounds ──
                      // Computed automatically from the polygon bounding box
                      cameraConstraint: bounds != null
                          ? CameraConstraint.containCenter(bounds: bounds)
                          : const CameraConstraint.unconstrained(),
                    ),
                    children: [
                      // ── Tile layer: OpenStreetMap ─────────────────────────
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.ecoguardianes.app',
                      ),

                      // ── Park boundary polygon ─────────────────────────────
                      if (polygon != null)
                        PolygonLayer(
                          polygons: [
                            Polygon(
                              points: polygon,
                              // Subtle fill inside park
                              color: AppColors.neonGreen.withValues(alpha: 0.07),
                              // Bright blue border tracing the real park shape
                              borderColor: Colors.blueAccent.withValues(alpha: 0.9),
                              borderStrokeWidth: 4.0,
                            ),
                          ],
                        ),

                      // ── Eco-station markers ───────────────────────────────
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

            // ── Legend ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(color: AppColors.neonGreen, label: 'Eco-Estación'),
                  const SizedBox(width: 20),
                  _LegendItem(color: AppColors.accentYellow, label: 'x2 Puntos'),
                  const SizedBox(width: 20),
                  _LegendItem(color: AppColors.accentRed, label: 'Saturada'),
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
      width: station.isDoublePoints ? 100 : 52,
      height: 52,
      child: GestureDetector(
        onTap: () => _showStationInfo(context, station),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    BorderRadius.circular(station.isDoublePoints ? 20 : 50),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.55),
                    blurRadius: 14,
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
                label: '¡Puntos x2 activos ahora!',
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

// ── Pulsing green online indicator ─────────────────────────────────────────
class _PulsingDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.neonGreen,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .scaleXY(begin: 1.0, end: 1.6, duration: 900.ms, curve: Curves.easeOut)
        .then()
        .scaleXY(begin: 1.6, end: 1.0, duration: 900.ms);
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
