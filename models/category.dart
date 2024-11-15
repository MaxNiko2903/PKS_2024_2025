class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  // Метод для создания объекта Category из JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: json['name'] as String,
    );
  }

  // Метод для преобразования объекта Category в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
