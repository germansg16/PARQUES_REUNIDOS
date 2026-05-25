import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/mock_repository.dart';
import '../models/eco_station_model.dart';
import '../models/mission_model.dart';

final stationsProvider = Provider<List<EcoStationModel>>(
  (ref) => MockRepository.getStations(),
);

final dailyMissionProvider = Provider<MissionModel>(
  (ref) => MockRepository.getDailyMission(),
);
