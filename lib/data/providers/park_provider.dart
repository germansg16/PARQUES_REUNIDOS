import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/park_model.dart';

final selectedParkProvider = StateProvider<ParkModel?>((ref) => null);
