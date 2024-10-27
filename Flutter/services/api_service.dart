import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:svk/models/token.dart';
import 'package:svk/models/user.dart';
import 'package:svk/models/userdata.dart';

class ApiService {
  final String _baseUrl = 'http://127.0.0.1:8000';

  Future<Token?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/token'),
        body: {
          'username': email,
          'password': password,
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        return Token.fromJson(json.decode(response.body));
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile(int userId, Token token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: {
          'Authorization': 'Bearer ${token.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch profile with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<bool> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        body: json.encode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }



  Future<UserData?> fetchCurrentUser(Token token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me'), // Новый эндпоинт
        headers: {
          'Authorization': 'Bearer ${token.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        return UserData.fromJson(json.decode(response.body));
      } else {
        print('Failed to fetch user data with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }


  Future<void> fetchProtectedResource(Token token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/protected-endpoint'),
        headers: {
          'Authorization': 'Bearer ${token.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        print('Fetched resource: ${response.body}');
      } else {
        print('Failed to fetch resource: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching resource: $e');
    }
  }
}
