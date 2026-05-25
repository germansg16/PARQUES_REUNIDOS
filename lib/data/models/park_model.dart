import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'eco_station_model.dart';

class ParkModel {
  final String id;
  final String name;
  final String shortName;
  final String country;
  final String emoji;
  final Color accentColor;
  final LatLng center;
  final LatLngBounds bounds;
  final double initialZoom;
  final double minZoom;
  final List<EcoStationModel> stations;

  const ParkModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.country,
    required this.emoji,
    required this.accentColor,
    required this.center,
    required this.bounds,
    required this.initialZoom,
    required this.minZoom,
    required this.stations,
  });
}

/// Catalogue of all Parques Reunidos parks with real GPS coordinates
class ParkCatalogue {
  ParkCatalogue._();

  static List<ParkModel> get all => [
        // ── España ──────────────────────────────────────────────────
        ParkModel(
          id: 'parque-de-atracciones-madrid',
          name: 'Parque de Atracciones de Madrid',
          shortName: 'P. Atracciones Madrid',
          country: '🇪🇸 Madrid, España',
          emoji: '🎢',
          accentColor: const Color(0xFFFF4D8D),
          center: const LatLng(40.4059, -3.7494),
          bounds: LatLngBounds(
            const LatLng(40.4020, -3.7560),
            const LatLng(40.4110, -3.7420),
          ),
          initialZoom: 16.0,
          minZoom: 15.0,
          stations: [
            EcoStationModel(
              id: 'pam-001',
              name: 'Eco-Estación Entrada Principal',
              position: const LatLng(40.4062, -3.7490),
              zone: 'Entrada',
            ),
            EcoStationModel(
              id: 'pam-002',
              name: 'Eco-Estación Zona Infantil',
              position: const LatLng(40.4070, -3.7505),
              isDoublePoints: true,
              zone: 'Zona Infantil',
            ),
            EcoStationModel(
              id: 'pam-003',
              name: 'Eco-Estación Restaurante Central',
              position: const LatLng(40.4058, -3.7480),
              zone: 'Restaurante',
            ),
            EcoStationModel(
              id: 'pam-004',
              name: 'Eco-Estación Zona Aventura',
              position: const LatLng(40.4048, -3.7488),
              isSaturated: true,
              zone: 'Zona Aventura',
            ),
            EcoStationModel(
              id: 'pam-005',
              name: 'Eco-Estación Salida',
              position: const LatLng(40.4065, -3.7470),
              isDoublePoints: true,
              zone: 'Salida',
            ),
          ],
        ),

        ParkModel(
          id: 'zoo-aquarium-madrid',
          name: 'Zoo Aquarium de Madrid',
          shortName: 'Zoo Aquarium Madrid',
          country: '🇪🇸 Madrid, España',
          emoji: '🦁',
          accentColor: const Color(0xFF4CAF50),
          center: const LatLng(40.4067, -3.7505),
          bounds: LatLngBounds(
            const LatLng(40.4020, -3.7560),
            const LatLng(40.4120, -3.7440),
          ),
          initialZoom: 16.0,
          minZoom: 15.0,
          stations: [
            EcoStationModel(
              id: 'zoo-001',
              name: 'Eco-Estación Entrada Zoo',
              position: const LatLng(40.4067, -3.7502),
              zone: 'Entrada',
            ),
            EcoStationModel(
              id: 'zoo-002',
              name: 'Eco-Estación Zona Felinos',
              position: const LatLng(40.4079, -3.7491),
              isDoublePoints: true,
              zone: 'Felinos',
            ),
            EcoStationModel(
              id: 'zoo-003',
              name: 'Eco-Estación Delfinario',
              position: const LatLng(40.4054, -3.7510),
              zone: 'Delfinario',
            ),
            EcoStationModel(
              id: 'zoo-004',
              name: 'Eco-Estación Panda Gigante',
              position: const LatLng(40.4065, -3.7520),
              isDoublePoints: true,
              zone: 'Área Panda',
            ),
            EcoStationModel(
              id: 'zoo-005',
              name: 'Eco-Estación Food Court',
              position: const LatLng(40.4043, -3.7498),
              isSaturated: true,
              zone: 'Restaurante',
            ),
          ],
        ),

        ParkModel(
          id: 'warner-madrid',
          name: 'Warner Bros. Park Madrid',
          shortName: 'Warner Bros. Park',
          country: '🇪🇸 San Martín de la Vega, España',
          emoji: '🦸',
          accentColor: const Color(0xFFFFD700),
          center: const LatLng(40.2073, -3.5688),
          bounds: LatLngBounds(
            const LatLng(40.2010, -3.5770),
            const LatLng(40.2140, -3.5600),
          ),
          initialZoom: 15.5,
          minZoom: 14.5,
          stations: [
            EcoStationModel(
              id: 'wb-001',
              name: 'Eco-Estación DC Universe',
              position: const LatLng(40.2073, -3.5685),
              isDoublePoints: true,
              zone: 'DC Universe',
            ),
            EcoStationModel(
              id: 'wb-002',
              name: 'Eco-Estación Hollywood Boulevard',
              position: const LatLng(40.2085, -3.5695),
              zone: 'Hollywood Blvd',
            ),
            EcoStationModel(
              id: 'wb-003',
              name: 'Eco-Estación Old West',
              position: const LatLng(40.2060, -3.5670),
              isSaturated: true,
              zone: 'Old West Territory',
            ),
            EcoStationModel(
              id: 'wb-004',
              name: 'Eco-Estación Cartoon Village',
              position: const LatLng(40.2090, -3.5678),
              zone: 'Cartoon Village',
            ),
            EcoStationModel(
              id: 'wb-005',
              name: 'Eco-Estación Superhero Area',
              position: const LatLng(40.2068, -3.5705),
              isDoublePoints: true,
              zone: 'Superhero Area',
            ),
          ],
        ),

        // ── Italia ──────────────────────────────────────────────────
        ParkModel(
          id: 'mirabilandia',
          name: 'Mirabilandia',
          shortName: 'Mirabilandia',
          country: '🇮🇹 Ravenna, Italia',
          emoji: '🎡',
          accentColor: const Color(0xFF2196F3),
          center: const LatLng(44.3363, 12.2675),
          bounds: LatLngBounds(
            const LatLng(44.3300, 12.2600),
            const LatLng(44.3430, 12.2760),
          ),
          initialZoom: 15.5,
          minZoom: 14.5,
          stations: [
            EcoStationModel(
              id: 'mir-001',
              name: 'Eco-Station Entrance',
              position: const LatLng(44.3363, 12.2678),
              zone: 'Entrance',
            ),
            EcoStationModel(
              id: 'mir-002',
              name: 'Eco-Station Water World',
              position: const LatLng(44.3375, 12.2690),
              isDoublePoints: true,
              zone: 'Water World',
            ),
            EcoStationModel(
              id: 'mir-003',
              name: 'Eco-Station Food Plaza',
              position: const LatLng(44.3350, 12.2665),
              isSaturated: true,
              zone: 'Food Plaza',
            ),
          ],
        ),

        // ── USA ──────────────────────────────────────────────────────
        ParkModel(
          id: 'palace-playland',
          name: 'Palace Playland',
          shortName: 'Palace Playland',
          country: '🇺🇸 Old Orchard Beach, USA',
          emoji: '🎠',
          accentColor: const Color(0xFFFF5722),
          center: const LatLng(43.5189, -70.3742),
          bounds: LatLngBounds(
            const LatLng(43.5150, -70.3800),
            const LatLng(43.5230, -70.3680),
          ),
          initialZoom: 16.0,
          minZoom: 15.0,
          stations: [
            EcoStationModel(
              id: 'pp-001',
              name: 'Eco-Station Boardwalk',
              position: const LatLng(43.5189, -70.3742),
              zone: 'Boardwalk',
            ),
            EcoStationModel(
              id: 'pp-002',
              name: 'Eco-Station Beach Area',
              position: const LatLng(43.5200, -70.3730),
              isDoublePoints: true,
              zone: 'Beach',
            ),
            EcoStationModel(
              id: 'pp-003',
              name: 'Eco-Station Food Court',
              position: const LatLng(43.5178, -70.3750),
              zone: 'Food Court',
            ),
          ],
        ),
      ];
}
