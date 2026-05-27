import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WheelState { idle, spinning, result }

class WheelStateNotifier extends StateNotifier<WheelState> {
  WheelStateNotifier() : super(WheelState.idle);

  void startSpin() => state = WheelState.spinning;
  void showResult() => state = WheelState.result;
  void reset() => state = WheelState.idle;
}

final wheelStateProvider =
    StateNotifierProvider<WheelStateNotifier, WheelState>(
  (ref) => WheelStateNotifier(),
);

final wheelResultIndexProvider = StateProvider<int>((ref) => 0);

final scanSuccessOverlayProvider = StateProvider<bool>((ref) => false);
