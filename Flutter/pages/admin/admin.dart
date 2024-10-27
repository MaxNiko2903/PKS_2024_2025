import 'package:flutter/material.dart';


class AdminDashboard extends StatelessWidget {
  final int userRole;

  AdminDashboard({required this.userRole});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> tiles = [
      {"title": "Разделы", "route": "/sections"},
      {"title": "Товары", "route": "/products"},
      {"title": "Заказы", "route": "/orders"},
      {"title": "Промокоды", "route": "/promo-codes"},
      {"title": "Банеры", "route": "/banners"},
      {"title": "Статистика", "route": "/statistics"},
      {"title": "Пользователи", "route": "/users"},
      {"title": "Модераторы", "route": "/moderators"}
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.brown[800],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of tiles in a row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          return InkWell( // Making each tile clickable
            onTap: () {
              // Navigate to the respective route
              Navigator.pushNamed(context, tiles[index]["route"]!);
            },
            child: Card(
              elevation: 4,
              child: Center(
                child: Text(
                  tiles[index]["title"]!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
