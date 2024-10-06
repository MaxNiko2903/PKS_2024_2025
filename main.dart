import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<int> _favorites = [];

  final List<Map<String, String>> _products = [
    {'name': 'Product 1', 'image': 'https://sun9-50.userapi.com/impg/X7t8ttbSvHV1W6XuSdIqo0G5ugJvbxpr9bVjOw/ATBSqEWTauw.jpg?size=952x648&quality=96&sign=99df3947fa3f06101613b86f1972764f&c_uniq_tag=izCF-7k-QxSXYPAPn9ZyMz1StQ7wYR1l3agLGMP-0Dk&type=album'},
    {'name': 'Product 2', 'image': 'https://sun9-64.userapi.com/impg/-tFViVGUHvgEyBPoU6rcAiBQ3iwzZzekv86LBg/uWOREUqOkHE.jpg?size=1080x1080&quality=95&sign=60ccac17b777c0b99fa229bc56efe218&type=album'},
    {'name': 'Product 3', 'image': 'https://sun9-4.userapi.com/impg/r6xVdH8AFY6D_PC_KRb7zOMZctsjgw9AkTWZeg/Ick3ZsSGtYY.jpg?size=1080x1080&quality=95&sign=90e108fc85e19afaf52cbf0a0aee0920&type=album'},
    {'name': 'Product 4', 'image': 'https://sun9-10.userapi.com/impg/-mxY8X0xi67hzDpsDkN5ABWZLhNa8bnWGA0z-w/nsfBjX-I2LY.jpg?size=1080x1080&quality=95&sign=4334237ae13a051e0a9eb4c696562ce0&type=album'},
    {'name': 'Product 5', 'image': 'https://sun9-17.userapi.com/impg/ya5rigj62SA5ZtHZ3RD4Hfug0l6IA4vwSAgVUA/dcoMv_T9ogo.jpg?size=1080x1080&quality=95&sign=b60e9ba035fd17c828b4db10fe9c22c2&type=album'},
  ];

  void _toggleFavorite(int index) {
    setState(() {
      if (_favorites.contains(index)) {
        _favorites.remove(index);
      } else {
        _favorites.add(index);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Товары')),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildCatalog(context),
            _buildFavorites(context),
            _buildProfile(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Каталог'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildCatalog(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width < 600 ? 1 : 2;

    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4.0,
          child: Column(
            children: [
              Image.network(
                _products[index]['image']!,
                height: 100,
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_products[index]['name']!),
              ),
              IconButton(
                icon: Icon(
                  _favorites.contains(index)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _favorites.contains(index) ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(index),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _products.removeAt(index);
                    _favorites.remove(index);
                  });
                },
                child: Text('Удалить'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavorites(BuildContext context) {
    if (_favorites.isEmpty) {
      return Center(
        child: Text('Нет избранных товаров'),
      );
    }

    int crossAxisCount = MediaQuery.of(context).size.width < 600 ? 1 : 2;

    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        int productIndex = _favorites[index];
        return Card(
          elevation: 4.0,
          child: Column(
            children: [
              Image.network(
                _products[productIndex]['image']!,
                height: 100,
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_products[productIndex]['name']!),
              ),
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () => _toggleFavorite(productIndex),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://sun9-40.userapi.com/impg/CsuZEXKeNiFtOzVEOZlD6GXAKL8EUsOYI5sNzg/f9ZzZs6JpIw.jpg?size=1600x1453&quality=95&sign=ac694404473f3c9b219a3bd7815cb47a&type=album', // Ссылка на изображение профиля
            ),
          ),
          SizedBox(height: 20),
          Text('ФИО: Николаев Максим Дмитриевич'),
          Text('Группа: ЭФБО-07-22'),
          Text('Телефон: +7 (123) 456-7890'),
          Text('Почта: 2903maxim123@gmail.com'),
        ],
      ),
    );
  }
}
