import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:svk/models/dop_model_product.dart';
import 'package:svk/models/category.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  // Функция для получения деталей конкретного продукта
  Future<Product> fetchProductDetails(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$productId'));

    if (response.statusCode == 200) {
      // Принудительное декодирование в UTF-8
      final decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> data = json.decode(decodedBody);
      return Product.fromJson(data);
    } else {
      throw Exception('Ошибка загрузки деталей продукта');
    }
  }

  // Fetch Categories from API
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      // Принудительное декодирование в UTF-8
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(decodedBody);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки категорий');
    }
  }

  // Fetch Products by Category from API
  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/products?category_id=$categoryId'));

    if (response.statusCode == 200) {
      // Принудительное декодирование в UTF-8
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(decodedBody);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки продуктов по категории');
    }
  }

  // Fetch Image URL
  Future<String> fetchImageUrl(String imageName) async {
    final response = await http.get(Uri.parse('$baseUrl/images/$imageName'));

    if (response.statusCode == 200) {
      // URL изображения не нуждается в декодировании, возвращаем как есть
      return '$baseUrl/images/$imageName';
    } else {
      throw Exception('Ошибка загрузки изображения');
    }
  }
}
