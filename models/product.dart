class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls; // Добавлено поле для URL-адресов изображений

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
  });

  // Конструктор для создания объекта `Product` из JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] ?? []), // Преобразование JSON-поля в список URL-адресов
    );
  }

  // Метод для преобразования объекта `Product` в JSON, если потребуется
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
    };
  }
}
