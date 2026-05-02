class Region {
  final String code;
  final String name;
  final int? provinceCode;

  Region({
    required this.code,
    required this.name,
    this.provinceCode,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      code: json['code']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      provinceCode: json['provinceCode'] ?? json['province_code'] != null
          ? int.tryParse(json['province_code'].toString())
          : null,
    );
  }
}

class Province {
  final String code;
  final String name;

  Province({required this.code, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json['code']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }
}