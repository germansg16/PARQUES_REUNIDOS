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
  /// Real polygon from OpenStreetMap (OSM way/relation geojson).
  /// GeoJSON [lng, lat] pairs converted to LatLng(lat, lng).
  final List<LatLng> polygon;
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
    required this.polygon,
    required this.initialZoom,
    required this.minZoom,
    required this.stations,
  });

  /// Tight LatLngBounds computed automatically from the real OSM polygon.
  LatLngBounds get bounds {
    double minLat = polygon.first.latitude;
    double maxLat = polygon.first.latitude;
    double minLng = polygon.first.longitude;
    double maxLng = polygon.first.longitude;
    for (final p in polygon) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    const pad = 0.001;
    return LatLngBounds(
      LatLng(minLat - pad, minLng - pad),
      LatLng(maxLat + pad, maxLng + pad),
    );
  }
}

/// ──────────────────────────────────────────────────────────────────────────
/// 3 parks with polygons sourced directly from OpenStreetMap via Nominatim.
/// GeoJSON coordinates are [lng, lat] → converted to LatLng(lat, lng).
/// ──────────────────────────────────────────────────────────────────────────
class ParkCatalogue {
  ParkCatalogue._();

  static List<ParkModel> get all => [
        _parqueDeAtracciones,
        _warnerMadrid,
        _mirabilandia,
      ];

  // ── 1. Parque de Atracciones de Madrid ─────────────────────────────────
  // OSM: way/6176205  |  Nominatim place_id: 294693032
  // Center (OSM lat/lon): 40.4116032, -3.7499124
  // Polygon: 28 nodes from OSM geojson (last = first, so we drop it)
  static final _parqueDeAtracciones = ParkModel(
    id: 'parque-de-atracciones-madrid',
    name: 'Parque de Atracciones de Madrid',
    shortName: 'P. Atracciones Madrid',
    country: '🇪🇸 Madrid, España',
    emoji: '🎢',
    accentColor: const Color(0xFFFF4D8D),
    center: const LatLng(40.4116, -3.7499),
    initialZoom: 16.5,
    minZoom: 15.5,
    polygon: const [
      LatLng(40.4101432, -3.753105),
      LatLng(40.4099743, -3.7530665),
      LatLng(40.4092996, -3.7524472),
      LatLng(40.4090087, -3.7521802),
      LatLng(40.4089829, -3.7521565),
      LatLng(40.4088909, -3.7520720),
      LatLng(40.4088051, -3.7519869),
      LatLng(40.4087886, -3.7519705),
      LatLng(40.4088602, -3.7518340),
      LatLng(40.4089297, -3.7517016),
      LatLng(40.4107583, -3.7481957),
      LatLng(40.4111232, -3.7475289),
      LatLng(40.4114247, -3.7471018),
      LatLng(40.4117817, -3.7467267),
      LatLng(40.4120434, -3.7465079),
      LatLng(40.4122989, -3.7463646),
      LatLng(40.4124123, -3.7464129),
      LatLng(40.4141733, -3.7471623),
      LatLng(40.4141430, -3.7473034),
      LatLng(40.4136982, -3.7493782),
      LatLng(40.4133012, -3.7505607),
      LatLng(40.4131654, -3.7509443),
      LatLng(40.4130276, -3.7513053),
      LatLng(40.4129527, -3.7515015),
      LatLng(40.4127769, -3.7519624),
      LatLng(40.4125451, -3.7525537),
      LatLng(40.4123816, -3.7529236),
      LatLng(40.4108622, -3.7528982),
    ],
    stations: const [
      EcoStationModel(
        id: 'pam-001',
        name: 'Eco-Estación Entrada Principal',
        position: LatLng(40.4093, -3.7519),
        zone: 'Entrada',
      ),
      EcoStationModel(
        id: 'pam-002',
        name: 'Eco-Estación Zona Nickelodeon',
        position: LatLng(40.4110, -3.7510),
        isDoublePoints: true,
        zone: 'Zona Nickelodeon',
      ),
      EcoStationModel(
        id: 'pam-003',
        name: 'Eco-Estación Restaurante Central',
        position: LatLng(40.4118, -3.7495),
        zone: 'Restaurante',
      ),
      EcoStationModel(
        id: 'pam-004',
        name: 'Eco-Estación Zona Aventura',
        position: LatLng(40.4126, -3.7479),
        isSaturated: true,
        zone: 'Zona Aventura',
      ),
      EcoStationModel(
        id: 'pam-005',
        name: 'Eco-Estación Zona Tranquilidad',
        position: LatLng(40.4133, -3.7490),
        isDoublePoints: true,
        zone: 'Zona Tranquilidad',
      ),
    ],
  );

  // ── 2. Parque Warner Madrid ─────────────────────────────────────────────
  // OSM: way/28092106  |  Nominatim place_id: 289867416
  // Center (OSM lat/lon): 40.2294449, -3.5928263
  // Polygon: 54 nodes from OSM geojson
  static final _warnerMadrid = ParkModel(
    id: 'parque-warner-madrid',
    name: 'Parque Warner Madrid',
    shortName: 'Warner Madrid',
    country: '🇪🇸 San Martín de la Vega, España',
    emoji: '🦸',
    accentColor: const Color(0xFFFFD700),
    center: const LatLng(40.2294, -3.5928),
    initialZoom: 15.5,
    minZoom: 14.5,
    polygon: const [
      LatLng(40.2311977, -3.5983098),
      LatLng(40.2304769, -3.5981982),
      LatLng(40.2297299, -3.5976145),
      LatLng(40.2291598, -3.5976060),
      LatLng(40.2287928, -3.5974772),
      LatLng(40.2284898, -3.5971726),
      LatLng(40.2279934, -3.5963614),
      LatLng(40.2278295, -3.5962413),
      LatLng(40.2274298, -3.5963271),
      LatLng(40.2269711, -3.5964387),
      LatLng(40.2267155, -3.5963099),
      LatLng(40.2264583, -3.5959280),
      LatLng(40.2263727, -3.5955565),
      LatLng(40.2263879, -3.5951598),
      LatLng(40.2264546, -3.5948074),
      LatLng(40.2265787, -3.5944656),
      LatLng(40.2267122, -3.5943026),
      LatLng(40.2270932, -3.5940478),
      LatLng(40.2273185, -3.5939485),
      LatLng(40.2275255, -3.5937341),
      LatLng(40.2277162, -3.5935036),
      LatLng(40.2277635, -3.5933724),
      LatLng(40.2277749, -3.5924967),
      LatLng(40.2277724, -3.5918497),
      LatLng(40.2277699, -3.5915513),
      LatLng(40.2267332, -3.5907726),
      LatLng(40.2268187, -3.5901387),
      LatLng(40.2276640, -3.5898415),
      LatLng(40.2290345, -3.5883941),
      LatLng(40.2299166, -3.5876379),
      LatLng(40.2327049, -3.5877579),
      LatLng(40.2327305, -3.5903026),
      LatLng(40.2324811, -3.5902967),
      LatLng(40.2320568, -3.5932520),
      LatLng(40.2321593, -3.5936106),
      LatLng(40.2323887, -3.5938681),
      LatLng(40.2324351, -3.5940634),
      LatLng(40.2323636, -3.5945236),
      LatLng(40.2324916, -3.5947635),
      LatLng(40.2323639, -3.5949226),
      LatLng(40.2319300, -3.5951555),
      LatLng(40.2319120, -3.5955203),
      LatLng(40.2319434, -3.5958786),
      LatLng(40.2319156, -3.5963221),
      LatLng(40.2324033, -3.5963367),
      LatLng(40.2324566, -3.5965551),
      LatLng(40.2325293, -3.5965803),
      LatLng(40.2324014, -3.5972222),
      LatLng(40.2322357, -3.5974492),
      LatLng(40.2319456, -3.5971716),
      LatLng(40.2318750, -3.5969520),
      LatLng(40.2318049, -3.5968716),
      LatLng(40.2317471, -3.5969791),
      LatLng(40.2315974, -3.5977004),
    ],
    stations: const [
      EcoStationModel(
        id: 'wb-001',
        name: 'Eco-Estación DC Super Heroes World',
        position: LatLng(40.2310, -3.5940),
        isDoublePoints: true,
        zone: 'DC Super Heroes',
      ),
      EcoStationModel(
        id: 'wb-002',
        name: 'Eco-Estación Hollywood Boulevard',
        position: LatLng(40.2295, -3.5930),
        zone: 'Hollywood Blvd',
      ),
      EcoStationModel(
        id: 'wb-003',
        name: 'Eco-Estación Old West Territory',
        position: LatLng(40.2278, -3.5945),
        isSaturated: true,
        zone: 'Old West',
      ),
      EcoStationModel(
        id: 'wb-004',
        name: 'Eco-Estación Cartoon Village',
        position: LatLng(40.2290, -3.5960),
        zone: 'Cartoon Village',
      ),
      EcoStationModel(
        id: 'wb-005',
        name: 'Eco-Estación Superman Zone',
        position: LatLng(40.2308, -3.5958),
        isDoublePoints: true,
        zone: 'Superman Zone',
      ),
    ],
  );

  // ── 3. Mirabilandia ─────────────────────────────────────────────────────
  // OSM: way/361037743  |  Nominatim place_id: 78951857
  // Center (OSM lat/lon): 44.3377141, 12.2626104
  // Polygon: 24 nodes from OSM geojson
  static final _mirabilandia = ParkModel(
    id: 'mirabilandia',
    name: 'Mirabilandia',
    shortName: 'Mirabilandia',
    country: '🇮🇹 Ravenna, Italia',
    emoji: '🎡',
    accentColor: const Color(0xFF2196F3),
    center: const LatLng(44.3377, 12.2626),
    initialZoom: 15.5,
    minZoom: 14.5,
    polygon: const [
      LatLng(44.3405905, 12.2550153),
      LatLng(44.3387178, 12.2566672),
      LatLng(44.3377831, 12.2574027),
      LatLng(44.3376450, 12.2577965),
      LatLng(44.3360134, 12.2595650),
      LatLng(44.3358482, 12.2598087),
      LatLng(44.3353742, 12.2603165),
      LatLng(44.3339088, 12.2620987),
      LatLng(44.3343061, 12.2629290),
      LatLng(44.3344137, 12.2631538),
      LatLng(44.3366979, 12.2684201),
      LatLng(44.3393987, 12.2662968),
      LatLng(44.3396644, 12.2660442),
      LatLng(44.3402347, 12.2655430),
      LatLng(44.3401625, 12.2649523),
      LatLng(44.3401554, 12.2643910),
      LatLng(44.3400470, 12.2638002),
      LatLng(44.3400842, 12.2636442),
      LatLng(44.3401680, 12.2635336),
      LatLng(44.3404443, 12.2633083),
      LatLng(44.3406745, 12.2630294),
      LatLng(44.3399839, 12.2615380),
      LatLng(44.3415177, 12.2601004),
      LatLng(44.3410769, 12.2576110),
    ],
    stations: const [
      EcoStationModel(
        id: 'mir-001',
        name: 'Eco-Station Main Entrance',
        position: LatLng(44.3348, 12.2625),
        zone: 'Entrance',
      ),
      EcoStationModel(
        id: 'mir-002',
        name: 'Eco-Station iSpeed Zone',
        position: LatLng(44.3390, 12.2650),
        isDoublePoints: true,
        zone: 'iSpeed Zone',
      ),
      EcoStationModel(
        id: 'mir-003',
        name: 'Eco-Station Food Plaza',
        position: LatLng(44.3370, 12.2620),
        isSaturated: true,
        zone: 'Food Plaza',
      ),
      EcoStationModel(
        id: 'mir-004',
        name: 'Eco-Station Water World',
        position: LatLng(44.3380, 12.2595),
        isDoublePoints: true,
        zone: 'Water World',
      ),
    ],
  );
}
