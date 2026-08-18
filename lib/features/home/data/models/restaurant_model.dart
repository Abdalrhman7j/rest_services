class RestaurantModel {
  const RestaurantModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.deliveryTime,
    required this.category,
    this.description = '',
    this.imageUrl = '',
  });

  final String id;
  final String name;
  final double rating;
  final int deliveryTime;
  final String category;
  final String description;
  final String imageUrl;

  factory RestaurantModel.fromMap(String id, Map<String, dynamic> map) {
    return RestaurantModel(
      id: id,
      name: map['name'] as String? ?? 'Unnamed restaurant',
      rating: (map['rating'] as num? ?? 0).toDouble(),
      deliveryTime: (map['deliveryTime'] as num? ?? 0).toInt(),
      category: map['category'] as String? ?? 'Other',
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }
}
