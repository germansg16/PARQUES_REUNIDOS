import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/mock_repository.dart';

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(MockRepository.getUser());

  void addRecycle() {
    state = state.copyWith(
      recycleCount: state.recycleCount + 1,
      currentExp: (state.currentExp + 15).clamp(0, state.maxExp),
      co2Saved: state.co2Saved + 0.18,
    );
  }

  void addPrize() {
    state = state.copyWith(
      prizeCount: state.prizeCount + 1,
    );
  }

  void addExp(int amount) {
    state = state.copyWith(
      currentExp: (state.currentExp + amount).clamp(0, state.maxExp),
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>(
  (ref) => UserNotifier(),
);
