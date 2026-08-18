import '../../../menu/data/models/product_model.dart';

class CartItemModel {
  const CartItemModel({
    required this.productId,
    required this.restaurantId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  final String productId;
  final String restaurantId;
  final String name;
  final double unitPrice;
  final int quantity;

  double get total => unitPrice * quantity;

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] as String? ?? '',
      restaurantId: map['restaurantId'] as String? ?? '',
      name: map['name'] as String? ?? 'Item',
      unitPrice: (map['unitPrice'] as num? ?? 0).toDouble(),
      quantity: (map['quantity'] as num? ?? 1).toInt(),
    );
  }

  factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItemModel(
      productId: product.id,
      restaurantId: product.restaurantId,
      name: product.name,
      unitPrice: product.price,
      quantity: quantity,
    );
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'restaurantId': restaurantId,
        'name': name,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };
}
