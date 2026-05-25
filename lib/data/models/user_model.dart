class UserModel {
  final String id;
  final String name;
  final String avatarUrl;
  final int level;
  final int currentExp;
  final int maxExp;
  final int recycleCount;
  final int prizeCount;
  final double co2Saved;

  const UserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.level,
    required this.currentExp,
    required this.maxExp,
    required this.recycleCount,
    required this.prizeCount,
    required this.co2Saved,
  });

  String get levelTitle => 'EcO-Héroe (Nvl $level)';
  double get expProgress => currentExp / maxExp;

  UserModel copyWith({
    int? recycleCount,
    int? prizeCount,
    int? currentExp,
    double? co2Saved,
  }) {
    return UserModel(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      level: level,
      currentExp: currentExp ?? this.currentExp,
      maxExp: maxExp,
      recycleCount: recycleCount ?? this.recycleCount,
      prizeCount: prizeCount ?? this.prizeCount,
      co2Saved: co2Saved ?? this.co2Saved,
    );
  }
}
