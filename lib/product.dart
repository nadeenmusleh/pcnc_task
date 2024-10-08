class Product {
  final int id;
  final String title;
  final double price;
  final List<String> images;
  final String description;
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.images,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
      description: json['description'],
    );
  }
}
