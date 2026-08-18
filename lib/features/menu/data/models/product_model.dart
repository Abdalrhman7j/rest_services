class ProductModel {
  const ProductModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.price,
    this.description = '',
    this.imageUrl = '',
    this.isAvailable = true,
  });

  final String id;
  final String restaurantId;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final bool isAvailable;

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      restaurantId: map['restaurantId'] as String? ?? '',
      name: map['name'] as String? ?? 'Unnamed item',
      price: (map['price'] as num? ?? 0).toDouble(),
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }
}
