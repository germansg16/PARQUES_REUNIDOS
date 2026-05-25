import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reward_model.dart';
import '../repositories/mock_repository.dart';

class WalletNotifier extends StateNotifier<List<RewardModel>> {
  WalletNotifier() : super(MockRepository.getWalletRewards());

  void addReward(RewardModel reward) {
    state = [reward, ...state];
  }

  void markAsUsed(String rewardId) {
    state = state.map((r) {
      if (r.id == rewardId) return r.copyWith(isUsed: true);
      return r;
    }).toList();
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, List<RewardModel>>(
  (ref) => WalletNotifier(),
);
