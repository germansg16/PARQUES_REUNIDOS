class MissionModel {
  final String id;
  final String title;
  final String description;
  final String targetStationId;
  final bool isCompleted;

  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.targetStationId,
    this.isCompleted = false,
  });
}
