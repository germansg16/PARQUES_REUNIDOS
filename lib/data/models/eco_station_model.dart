import 'package:latlong2/latlong.dart';

class EcoStationModel {
  final String id;
  final String name;
  final LatLng position;
  final bool isDoublePoints;
  final bool isSaturated;
  final String zone;

  const EcoStationModel({
    required this.id,
    required this.name,
    required this.position,
    this.isDoublePoints = false,
    this.isSaturated = false,
    required this.zone,
  });
}
