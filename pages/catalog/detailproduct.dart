import 'package:flutter/material.dart';
import 'package:svk/models/dop_model_product.dart';
import 'package:svk/services/api_dop.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ApiService _apiService = ApiService();
  Product? _product;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  void _loadProductDetails() async {
    try {
      Product product = await _apiService.fetchProductDetails(widget.productId);
      setState(() {
        _product = product;
      });
    } catch (e) {
      print('Ошибка загрузки деталей продукта: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_product?.name ?? 'Детали товара')),
      body: _product == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _product!.images.isNotEmpty
                ? Image.network(
              _apiService.baseUrl + '/images/' + _product!.images[0],
              height: 200,
              fit: BoxFit.cover,
            )
                : Container(
              height: 200,
              color: Colors.grey[200],
              child: Icon(Icons.image, size: 50),
            ),
            SizedBox(height: 16),
            Text(
              _product!.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (_product!.salePrice != null && _product!.salePrice! > 0)
              Row(
                children: [
                  Text(
                    '${_product!.price}₽',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${_product!.price - (_product!.price * _product!.salePrice! / 100).round()}₽',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                ],
              )
            else
              Text(
                '${_product!.price}₽',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            SizedBox(height: 16),
            Text('Описание:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(_product!.description),
            SizedBox(height: 16),
            Text('Дополнительные детали:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(_product!.additionalDetails),
            SizedBox(height: 16),
            Text('Габариты:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Высота: ${_product!.height} см'),
            Text('Ширина: ${_product!.width} см'),
            Text('Длина: ${_product!.length} см'),
            Text('Вес: ${_product!.weight} кг'),
            SizedBox(height: 16),
            Text('Время производства: ${_product!.productionTime} дней', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            // Галерея изображений
            if (_product!.images.length > 1)
              Text('Галерея изображений:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_product!.images.length > 1)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _product!.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.network(
                        _apiService.baseUrl + '/images/' + _product!.images[index],
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
