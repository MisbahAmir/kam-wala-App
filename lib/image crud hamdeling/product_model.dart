class ProductModel {
  final String id;
  final String protitle;
  final String description;
  final String price;
  final String category;
  final String image;

  ProductModel({
    required this.id,
    required this.protitle,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      protitle: data['protitle'] ?? '',
      description: data['Description'] ?? '',
      price: data['price'] ?? '',
      category: data['Category'] ?? '',
      image: data['Image'] ?? '',
    );
  }
}
