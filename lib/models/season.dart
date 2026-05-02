class Season {
  final int id;
  final String familyCode;
  final int year;
  final String name;
  final String? description;
  final bool isActive;
  final String? posterURL;

  Season({
    required this.id,
    required this.familyCode,
    required this.year,
    required this.name,
    this.description,
    required this.isActive,
    this.posterURL,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'] ?? 0,
      familyCode: json['familyCode'] ?? json['family_code'] ?? '',
      year: json['year'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      isActive: json['isActive'] ?? json['is_active'] ?? false,
      posterURL: json['posterURL'] ?? json['poster_url'],
    );
  }

  String get displayName => '$familyCode $year - $name';
}