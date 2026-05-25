import 'package:latlong2/latlong.dart';
import '../models/user_model.dart';
import '../models/eco_station_model.dart';
import '../models/reward_model.dart';
import '../models/mission_model.dart';

class MockRepository {
  static UserModel getUser() => const UserModel(
        id: 'user-001',
        name: 'Alex Martinez',
        avatarUrl: '',
        level: 3,
        currentExp: 250,
        maxExp: 300,
        recycleCount: 12,
        prizeCount: 4,
        co2Saved: 2.3,
      );

  static List<EcoStationModel> getStations() => [
        EcoStationModel(
          id: 'station-001',
          name: 'Eco-Estación Entrada',
          position: const LatLng(40.4180, -3.7030),
          zone: 'Entrada',
        ),
        EcoStationModel(
          id: 'station-002',
          name: 'Eco-Estación Safari x2',
          position: const LatLng(40.4192, -3.7015),
          isDoublePoints: true,
          zone: 'Zona Safari',
        ),
        EcoStationModel(
          id: 'station-003',
          name: 'Eco-Estación Restaurante',
          position: const LatLng(40.4175, -3.7020),
          isSaturated: true,
          zone: 'Restaurante Safari',
        ),
        EcoStationModel(
          id: 'station-004',
          name: 'Eco-Estación Lago',
          position: const LatLng(40.4185, -3.7045),
          zone: 'Zona Lago',
        ),
        EcoStationModel(
          id: 'station-005',
          name: 'Eco-Estación Sur x2',
          position: const LatLng(40.4165, -3.7035),
          isDoublePoints: true,
          zone: 'Zona Sur',
        ),
      ];

  static List<RewardModel> getWalletRewards() => [
        RewardModel(
          id: 'reward-001',
          title: 'Fast Pass',
          subtitle: 'Superman/Batman',
          type: RewardType.fastPass,
          expiresAt: DateTime.now().subtract(const Duration(hours: 2)),
          isUsed: true,
          barcodeData: 'ECP-FP-2024-001',
        ),
        RewardModel(
          id: 'reward-002',
          title: 'Helado 2×1',
          subtitle: 'En cualquier puesto',
          type: RewardType.iceCream,
          expiresAt: DateTime.now().add(const Duration(hours: 8)),
          barcodeData: 'ECP-4921-2X1',
        ),
        RewardModel(
          id: 'reward-003',
          title: '+30 Puntos EXP',
          subtitle: 'Bonificación especial',
          type: RewardType.points,
          expiresAt: DateTime.now().add(const Duration(days: 3)),
          barcodeData: 'ECP-PTS-0030-003',
        ),
      ];

  static MissionModel getDailyMission() => const MissionModel(
        id: 'mission-001',
        title: '¡Misión Especial!',
        description:
            'Faltan reciclar botellas. Eco-Estación con puntos x2 cerca del Restaurante Safari.',
        targetStationId: 'station-002',
      );

  static List<WheelSegment> getWheelSegments() => const [
        WheelSegment(
          label: '+10Pts',
          rewardType: RewardType.points,
          rewardTitle: '+10 Puntos',
          rewardSubtitle: 'Experiencia extra',
        ),
        WheelSegment(
          label: 'Helado',
          rewardType: RewardType.iceCream,
          rewardTitle: 'Helado 2×1',
          rewardSubtitle: 'En cualquier puesto',
        ),
        WheelSegment(
          label: 'Fast\nPass',
          rewardType: RewardType.fastPass,
          rewardTitle: 'Fast Pass',
          rewardSubtitle: 'Acceso prioritario',
        ),
        WheelSegment(
          label: '+30Pts',
          rewardType: RewardType.points,
          rewardTitle: '+30 Puntos',
          rewardSubtitle: '¡Súper bonificación!',
        ),
        WheelSegment(
          label: 'Foto',
          rewardType: RewardType.photo,
          rewardTitle: 'Foto Recuerdo',
          rewardSubtitle: 'Con el animal favorito',
        ),
        WheelSegment(
          label: '-10%',
          rewardType: RewardType.discount,
          rewardTitle: '10% Descuento',
          rewardSubtitle: 'En la tienda del parque',
        ),
      ];
}

class WheelSegment {
  final String label;
  final RewardType rewardType;
  final String rewardTitle;
  final String rewardSubtitle;

  const WheelSegment({
    required this.label,
    required this.rewardType,
    required this.rewardTitle,
    required this.rewardSubtitle,
  });
}
