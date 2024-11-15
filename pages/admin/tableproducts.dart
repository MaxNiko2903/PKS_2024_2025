import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:svk/pages/admin/editproduct.dart';
import 'package:svk/pages/admin/products.dart';  // Импортируем ProductPage

class ProductTablePage extends StatefulWidget {
  @override
  _ProductTablePageState createState() => _ProductTablePageState();
}

class _ProductTablePageState extends State<ProductTablePage> {
  List<dynamic> products = [];
  List<dynamic> categories = [];
  bool isLoading = false;
  String selectedCategory = 'Все';

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts(null);  // Загружаем все продукты при загрузке страницы
  }

  Future<void> fetchProducts(int? categoryId) async {
    setState(() => isLoading = true);
    final url = categoryId == null
        ? Uri.parse('http://127.0.0.1:8000/products')
        : Uri.parse('http://127.0.0.1:8000/products?category_id=$categoryId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(utf8.decode(response.bodyBytes)); // Декодируем как UTF-8
        isLoading = false;
      });
    }
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/categories'));

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(utf8.decode(response.bodyBytes)); // Декодируем как UTF-8
      });
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(Uri.parse('http://127.0.0.1:8000/products/$productId'));

    if (response.statusCode == 204) {
      fetchProducts(selectedCategory == 'Все' ? null : int.parse(selectedCategory));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          DropdownButton<String>(
            value: selectedCategory,
            items: [
              DropdownMenuItem(value: 'Все', child: Text('Все')),
              ...categories.map((category) {
                return DropdownMenuItem(
                  value: category['id'].toString(),
                  child: Text(category['name']),
                );
              }).toList(),
            ],
            onChanged: (String? value) {
              setState(() => selectedCategory = value!);
              fetchProducts((value == null || value == 'Все') ? null : int.parse(value));
            },
          ),
          Expanded(
            child: DataTable(
              columns: [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Price")),
                DataColumn(label: Text("Actions")),
              ],
              rows: products.map((product) {
                return DataRow(
                  cells: [
                    DataCell(Text(product['id'].toString())),
                    DataCell(Text(product['name'])),
                    DataCell(Text(product['price'].toString())),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductPage(productId: product['id']),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteProduct(product['id']),
                        ),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Переход на страницу добавления нового продукта
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }
}
