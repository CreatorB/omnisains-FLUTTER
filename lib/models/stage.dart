class Stage {
  final int id;
  final String stageCode;
  final String stageName;
  final String stageType;
  final int seasonId;
  final String? description;
  final List<String>? cityNames;
  final bool isRegistrationOpen;

  Stage({
    required this.id,
    required this.stageCode,
    required this.stageName,
    required this.stageType,
    required this.seasonId,
    this.description,
    this.cityNames,
    this.isRegistrationOpen = true,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] ?? 0,
      stageCode: json['stageCode'] ?? json['stage_code'] ?? '',
      stageName: json['stageName'] ?? json['stage_name'] ?? '',
      stageType: json['stageType'] ?? json['stage_type'] ?? '',
      seasonId: json['seasonId'] ?? json['season_id'] ?? 0,
      description: json['description'],
      cityNames: json['cityNames'] != null
          ? List<String>.from(json['cityNames'])
          : (json['city_names'] != null ? List<String>.from(json['city_names']) : null),
      isRegistrationOpen: json['isRegistrationOpen'] ?? json['is_registration_open'] ?? true,
    );
  }
}