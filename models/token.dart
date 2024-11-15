import 'dart:convert';

class Token {
  final String accessToken;
  final String tokenType;
  final String name; // Имя пользователя
  final String email; // Email пользователя
  final int roleId; // Роль пользователя

  Token({
    required this.accessToken,
    required this.tokenType,
    required this.name,
    required this.email,
    required this.roleId,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roleId: json['role_id'] ?? 0,
    );
  }

  // Метод для создания Token из строки JSON
  static Token fromString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Token.fromJson(json);
  }

  // Метод для преобразования Token в JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'name': name,
      'email': email,
      'role_id': roleId,
    };
  }
}
