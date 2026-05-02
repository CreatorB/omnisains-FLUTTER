class Participation {
  final int id;
  final String participantNumber;
  final int stageId;
  final String stageName;
  final String seasonName;
  final int seasonYear;
  final String familyCode;
  final String? status;
  final String? paymentStatus;
  final DateTime createdAt;

  Participation({
    required this.id,
    required this.participantNumber,
    required this.stageId,
    required this.stageName,
    required this.seasonName,
    required this.seasonYear,
    required this.familyCode,
    this.status,
    this.paymentStatus,
    required this.createdAt,
  });

  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'] ?? 0,
      participantNumber: json['participantNumber'] ?? json['participant_number'] ?? '',
      stageId: json['stageId'] ?? json['stage_id'] ?? 0,
      stageName: json['stageName'] ?? json['stage_name'] ?? '',
      seasonName: json['seasonName'] ?? json['season_name'] ?? '',
      seasonYear: json['seasonYear'] ?? json['season_year'] ?? 0,
      familyCode: json['familyCode'] ?? json['family_code'] ?? '',
      status: json['status'],
      paymentStatus: json['paymentStatus'] ?? json['payment_status'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : (json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
              : DateTime.now()),
    );
  }

  String get eventDisplayName => '$familyCode $seasonYear - $stageName';
}