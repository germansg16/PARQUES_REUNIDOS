import 'package:flutter/material.dart';

enum RewardType { fastPass, iceCream, photo, points, discount }

class RewardModel {
  final String id;
  final String title;
  final String subtitle;
  final RewardType type;
  final DateTime expiresAt;
  final bool isUsed;
  final String barcodeData;

  const RewardModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.expiresAt,
    this.isUsed = false,
    required this.barcodeData,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => !isUsed && !isExpired;

  String get expiryLabel {
    if (isUsed) return 'Ya utilizado.';
    if (isExpired) return 'Caducado.';
    final now = DateTime.now();
    final diff = expiresAt.difference(now);
    if (diff.inDays == 0) return 'Válido hoy';
    return 'Válido ${diff.inDays} día(s) más';
  }

  IconData get icon {
    switch (type) {
      case RewardType.fastPass:
        return Icons.confirmation_number_outlined;
      case RewardType.iceCream:
        return Icons.icecream_outlined;
      case RewardType.photo:
        return Icons.photo_camera_outlined;
      case RewardType.points:
        return Icons.bolt_outlined;
      case RewardType.discount:
        return Icons.local_offer_outlined;
    }
  }

  Color get accentColor {
    switch (type) {
      case RewardType.fastPass:
        return const Color(0xFF8B949E);
      case RewardType.iceCream:
        return const Color(0xFFFF4D8D);
      case RewardType.photo:
        return const Color(0xFF58A6FF);
      case RewardType.points:
        return const Color(0xFF00E676);
      case RewardType.discount:
        return const Color(0xFFFFD700);
    }
  }

  RewardModel copyWith({bool? isUsed}) {
    return RewardModel(
      id: id,
      title: title,
      subtitle: subtitle,
      type: type,
      expiresAt: expiresAt,
      isUsed: isUsed ?? this.isUsed,
      barcodeData: barcodeData,
    );
  }
}
