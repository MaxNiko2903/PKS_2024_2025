import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  final int productId;

  EditProductPage({required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для каждого поля ввода
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController productionTimeController = TextEditingController();
  final TextEditingController additionalDetailsController = TextEditingController();

  int categoryId = 0;
  List<String> currentImages = [];
  List<String> imagesToDelete = [];
  List<XFile> newImages = [];
  List<Map<String, dynamic>> categories = []; // Список категорий

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
    _fetchCategories(); // Загружаем категории при инициализации
  }

  Future<void> _fetchProductDetails() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/products/${widget.productId}'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)); // Декодируем как UTF-8
      setState(() {
        nameController.text = data['name'] ?? '';
        descriptionController.text = data['description'] ?? '';
        priceController.text = data['price'].toString();
        salePriceController.text = data['sale_price']?.toString() ?? '';
        categoryId = data['category_id'];
        heightController.text = data['height']?.toString() ?? '';
        widthController.text = data['width']?.toString() ?? '';
        lengthController.text = data['length']?.toString() ?? '';
        weightController.text = data['weight']?.toString() ?? '';
        productionTimeController.text = data['production_time']?.toString() ?? '';
        additionalDetailsController.text = data['additional_details'] ?? '';
        currentImages = List<String>.from(data['images']);
      });
    } else {
      print("Ошибка загрузки данных: ${response.statusCode}");
    }
  }


  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/categories'));
    if (response.statusCode == 200) {
      setState(() {
        categories = List<Map<String, dynamic>>.from(json.decode(utf8.decode(response.bodyBytes))); // Декодируем как UTF-8
      });
    } else {
      print("Ошибка загрузки категорий: ${response.statusCode}");
    }
  }


  Future<void> _updateProduct() async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://127.0.0.1:8000/products/${widget.productId}'),
    )
      ..fields['name'] = nameController.text
      ..fields['description'] = descriptionController.text
      ..fields['price'] = priceController.text
      ..fields['sale_price'] = salePriceController.text.isNotEmpty ? salePriceController.text : 'null'
      ..fields['category_id'] = categoryId.toString()
      ..fields['height'] = heightController.text
      ..fields['width'] = widthController.text
      ..fields['length'] = lengthController.text
      ..fields['weight'] = weightController.text
      ..fields['production_time'] = productionTimeController.text
      ..fields['additional_details'] = additionalDetailsController.text
      ..fields['delete_images'] = json.encode(imagesToDelete);  // Передаем как строку JSON для удаления

    // Добавляем новые изображения, если они есть
    for (var image in newImages) {
      final bytes = await image.readAsBytes();
      final file = http.MultipartFile.fromBytes('images', bytes, filename: image.name);
      request.files.add(file);
    }

    // Отправка запроса
    final response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print('Ошибка: ${response.statusCode}');
    }
  }


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        newImages.add(pickedFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Редактировать продукт')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Цена'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: salePriceController,
              decoration: InputDecoration(labelText: 'Цена со скидкой'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<int>(
              value: categoryId != 0 ? categoryId : null,
              onChanged: (value) => setState(() => categoryId = value ?? 0),
              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category['id'],
                  child: Text(category['name']),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Категория'),
            ),
            TextFormField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Высота'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: widthController,
              decoration: InputDecoration(labelText: 'Ширина'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: lengthController,
              decoration: InputDecoration(labelText: 'Длина'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Вес'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: productionTimeController,
              decoration: InputDecoration(labelText: 'Время производства'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: additionalDetailsController,
              decoration: InputDecoration(labelText: 'Дополнительные детали'),
            ),
            SizedBox(height: 20),
            Text("Текущие изображения", style: TextStyle(fontWeight: FontWeight.bold)),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: currentImages.length,
              itemBuilder: (context, index) {
                final imageName = currentImages[index];
                final imageUrl = 'http://127.0.0.1:8000/images/$imageName';
                return Stack(
                  children: [
                    Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            imagesToDelete.add(imageName);
                            currentImages.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Добавить изображение'),
            ),
            ElevatedButton(
              onPressed: _updateProduct,
              child: Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}
