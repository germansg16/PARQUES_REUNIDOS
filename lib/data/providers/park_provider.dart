import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/park_model.dart';

/// Holds the park selected by the user after the park-selection screen.
/// Null means no park has been selected yet (user is in login/selection flow).
final selectedParkProvider = StateProvider<ParkModel?>((ref) => null);
