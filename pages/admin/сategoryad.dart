import 'package:flutter/material.dart';
import 'package:svk/services/api_service.dart';
import 'package:svk/models/category.dart';

class AdminCategoryPage extends StatefulWidget {
  @override
  _AdminCategoryPageState createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  final ApiService _apiService = ApiService();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    try {
      _categories = await _apiService.fetchCategories();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки категорий: $error')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _createCategory(Category category) async {
    try {
      await _apiService.createCategory(category);
      _loadCategories(); // Обновляем список после создания
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка создания категории: $error')),
      );
    }
  }

  Future<void> _updateCategory(Category category) async {
    try {
      await _apiService.updateCategory(category);
      _loadCategories(); // Обновляем список после обновления
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка обновления категории: $error')),
      );
    }
  }

  Future<void> _deleteCategory(int id) async {
    try {
      await _apiService.deleteCategory(id);
      _loadCategories(); // Обновляем список после удаления
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления категории: $error')),
      );
    }
  }

  // Форма для добавления/редактирования категорий
  void _showCategoryForm({Category? category}) {
    final _nameController = TextEditingController(
      text: category != null ? category.name : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Создать категорию' : 'Редактировать категорию'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Название категории'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final newCategory = Category(
                id: category?.id,
                name: _nameController.text,
              );

              if (category == null) {
                _createCategory(newCategory);
              } else {
                _updateCategory(newCategory);
              }
              Navigator.of(context).pop();
            },
            child: Text(category == null ? 'Создать' : 'Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Управление категориями'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCategoryForm(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showCategoryForm(category: category),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (category.id != null) {
                      _deleteCategory(category.id!); // Используем ! для безопасного вызова
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: отсутствует ID категории')),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
