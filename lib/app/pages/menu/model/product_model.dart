class ProductModel {
  final int id;
  final String name;
  final String category;
  final String description;
  final String? image;
  final double price;
  final double rating;
  final int reviewCount;
  final String createdAt;
  final String updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.image,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category']['name'], // mengambil nama kategori
      description: json['description'],
      image: json['image'],
      price: double.parse(json['price']),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'image': image,
      'price': price.toString(),
      'rating': rating,
      'review_count': reviewCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
