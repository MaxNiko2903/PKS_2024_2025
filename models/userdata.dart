class UserData {
  final String name;
  final String email;
  final int roleId;

  UserData({
    required this.name,
    required this.email,
    required this.roleId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roleId: json['role_id'] ?? 0,
    );
  }
}
