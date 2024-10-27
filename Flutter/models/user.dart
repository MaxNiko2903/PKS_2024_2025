class User {
  final String name;
  final String email;
  final String password;
  final int roleId; // Добавлено поле roleId

  User({
    required this.name,
    required this.email,
    required this.password,
    this.roleId = 2, // Установите значение по умолчанию или передавайте при регистрации
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role_id': roleId, // Передаем roleId в JSON
    };
  }
}
