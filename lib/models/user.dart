class User {
  final String id;
  final String accountId;
  final String email;
  final String fullName;
  final String? schoolName;
  final String? phone;
  final String? province;
  final String? city;
  final String? district;
  final String? village;
  final String? address;
  final String? gradeLevel;
  final String? gender;
  final String role;

  User({
    required this.id,
    required this.accountId,
    required this.email,
    required this.fullName,
    this.schoolName,
    this.phone,
    this.province,
    this.city,
    this.district,
    this.village,
    this.address,
    this.gradeLevel,
    this.gender,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      accountId: json['accountId']?.toString() ?? json['account_id']?.toString() ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      schoolName: json['schoolName'] ?? json['school_name'],
      phone: json['phone'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      village: json['village'],
      address: json['address'],
      gradeLevel: json['gradeLevel'] ?? json['grade_level'],
      gender: json['gender'],
      role: json['role'] ?? 'participant',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountId': accountId,
      'email': email,
      'fullName': fullName,
      'schoolName': schoolName,
      'phone': phone,
      'province': province,
      'city': city,
      'district': district,
      'village': village,
      'address': address,
      'gradeLevel': gradeLevel,
      'gender': gender,
      'role': role,
    };
  }
}