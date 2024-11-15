import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:svk/models/token.dart';
import 'package:svk/models/user.dart';
import 'package:svk/models/userdata.dart';
import 'package:svk/models/userlist.dart';
import 'package:svk/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svk/models/product.dart';

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
        final token = Token.fromJson(json.decode(response.body));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', json.encode(token.toJson())); // Сохраняем токен
        return token;
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
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Authorization': 'Bearer ${token.accessToken}',
        },
      );

      print('Fetching user data with token: ${token.accessToken}'); // Логирование токена

      if (response.statusCode == 200) {
        return UserData.fromJson(json.decode(response.body));
      } else {
        print('Failed to fetch user data with status: ${response.statusCode}');
        print('Response body: ${response.body}'); // Логирование тела ответа
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

  Future<UserList?> fetchUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tokenString = prefs.getString('token');

      if (tokenString == null) {
        print('No token found. User is not logged in.');
        return null; // No token means the user is not logged in
      }

      final Token token = Token.fromString(tokenString); // Use your existing Token parsing logic

      final response = await http.get(
        Uri.parse('$_baseUrl/users'),
        headers: {
          'Authorization': 'Bearer ${token.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response to UserList
        return UserList.fromJson(json.decode(response.body));
      } else {
        print('Failed to load users: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null; // Return null in case of an error
      }
    } catch (e) {
      print('Error fetching users: $e');
      return null; // Handle exceptions appropriately
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories'));

    if (response.statusCode == 200) {
      // Декодируем данные как UTF-8 перед тем, как распарсить JSON
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки категорий');
    }
  }

  Future<void> createCategory(Category category) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/categories'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Ошибка создания категории');
    }
  }

  Future<void> updateCategory(Category category) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/categories/${category.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка обновления категории');
    }
  }

  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/categories/$id'));

    if (response.statusCode != 200) {
      throw Exception('Ошибка удаления категории');
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$_baseUrl/products?category_id=$categoryId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки продуктов');
    }
  }

}
