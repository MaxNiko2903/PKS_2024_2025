import 'package:svk/models/userdata.dart';
class UserList {
  final List<UserData> users;

  UserList({required this.users});

  factory UserList.fromJson(Map<String, dynamic> json) {
    var userList = json['items'] as List; // Используйте ключ 'items'
    List<UserData> users = userList.map((user) => UserData.fromJson(user)).toList();
    return UserList(users: users);
  }
}
