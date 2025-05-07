class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String? googleId;
  final String? avatar;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.googleId,
    this.avatar,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      googleId: json['google_id'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'google_id': googleId,
      'avatar': avatar,
      'role': role,
    };
  }
}
