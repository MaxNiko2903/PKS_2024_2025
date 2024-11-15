import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:svk/models/product.dart';
import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _description;
  double? _price;
  int? _categoryId;
  int? _productionTime;
  double? _height;
  double? _width;
  double? _length;
  double? _weight;
  String? _additionalDetails;
  List<XFile> _selectedImages = [];
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/categories'));
      if (response.statusCode == 200) {
        setState(() {
          _categories = List<Map<String, dynamic>>.from(json.decode(utf8.decode(response.bodyBytes))); // Декодируем как UTF-8
        });
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> _pickImages() async {
    final pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _selectedImages = pickedImages;
      });
    }
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final request = http.MultipartRequest('POST', Uri.parse('http://localhost:8000/products/'));
    request.fields['name'] = _name!;
    request.fields['description'] = _description ?? '';
    request.fields['price'] = _price.toString();
    request.fields['category_id'] = _categoryId.toString();
    request.fields['production_time'] = _productionTime.toString();
    request.fields['height'] = _height.toString();
    request.fields['width'] = _width.toString();
    request.fields['length'] = _length.toString();
    request.fields['weight'] = _weight.toString();
    request.fields['additional_details'] = _additionalDetails ?? '';

    for (var image in _selectedImages) {
      final bytes = await image.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'images',
        bytes,
        filename: image.name,
      ));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print("Product created successfully");
      } else {
        print("Failed to create product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error submitting product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Создание товара")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) => value == null || value.isEmpty ? 'Введите название' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Описание'),
                onSaved: (value) => _description = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Цена'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Введите цену' : null,
                onSaved: (value) => _price = double.parse(value!),
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Категория'),
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'],
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (value) => _categoryId = value,
                validator: (value) => value == null ? 'Выберите категорию' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Срок изготовления (дни)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _productionTime = int.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Высота'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _height = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ширина'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _width = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Длина'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _length = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Вес'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _weight = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Дополнительные детали'),
                onSaved: (value) => _additionalDetails = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text("Выбрать изображения"),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _selectedImages.map((image) {
                  return kIsWeb
                      ? Image.network(image.path, width: 100, height: 100, fit: BoxFit.cover)
                      : Image.file(File(image.path), width: 100, height: 100, fit: BoxFit.cover);
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProduct,
                child: Text("Создать товар"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
