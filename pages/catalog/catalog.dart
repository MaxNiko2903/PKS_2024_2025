// Измените код на CatalogPage для навигации к ProductDetailPage
import 'package:flutter/material.dart';
import 'package:svk/models/dop_model_product.dart';
import 'package:svk/services/api_dop.dart';
import 'package:svk/pages/catalog/detailproduct.dart'; // Импортируем ProductDetailPage
import 'package:svk/models/category.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ApiService _apiService = ApiService();
  List<Category> _categories = [];
  Category? _selectedCategory;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    try {
      List<Category> categories = await _apiService.fetchCategories();
      setState(() {
        _categories = categories;
        _selectedCategory = categories.isNotEmpty ? categories[0] : null;
        if (_selectedCategory?.id != null) {
          _loadProducts(_selectedCategory!.id!);
        } else {
          print("Category id is null.");
        }
      });
    } catch (e) {
      print('Ошибка загрузки категорий: $e');
    }
  }

  void _loadProducts(int categoryId) async {
    try {
      List<Product> products = await _apiService.fetchProductsByCategory(categoryId);
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Ошибка загрузки продуктов или изображений: $e');
    }
  }

  void _selectCategory(Category category) {
    setState(() {
      _selectedCategory = category;
      if (category.id != null) {
        _loadProducts(category.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Каталог')),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  title: Text(category.name),
                  selected: _selectedCategory == category,
                  onTap: () => _selectCategory(category),
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: _selectedCategory == null
                ? Center(child: Text('Выберите категорию', style: TextStyle(fontSize: 20)))
                : _products.isEmpty
                ? Center(child: CircularProgressIndicator())
                : LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(productId: product.id),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            product.images.isNotEmpty
                                ? CarouselSlider(
                              options: CarouselOptions(
                                height: constraints.maxHeight * 0.4,
                                viewportFraction: 1.0,
                                enableInfiniteScroll: false,
                              ),
                              items: product.images.map((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            _apiService.baseUrl +
                                                '/images/' +
                                                imageUrl,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            )
                                : Container(
                              height: constraints.maxHeight * 0.4,
                              color: Colors.grey[200],
                              child: Icon(Icons.image, size: 50),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '${product.price}₽',
                                style:
                                TextStyle(fontSize: 14, color: Colors.green),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
