class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final int? salePrice;
  final double height;
  final double width;
  final double length;
  final double weight;
  final int productionTime;
  final String additionalDetails;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.height,
    required this.width,
    required this.length,
    required this.weight,
    required this.productionTime,
    required this.additionalDetails,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      salePrice: json['sale_price'],
      height: json['height'].toDouble(),
      width: json['width'].toDouble(),
      length: json['length'].toDouble(),
      weight: json['weight'].toDouble(),
      productionTime: json['production_time'],
      additionalDetails: json['additional_details'],
      images: List<String>.from(json['images']),
    );
  }
}
