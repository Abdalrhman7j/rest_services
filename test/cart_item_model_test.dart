import 'package:atlab/features/cart/data/models/cart_item_model.dart';
import 'package:atlab/features/menu/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cart item retains product details and calculates its total', () {
    const product = ProductModel(
      id: 'burger-1',
      restaurantId: 'restaurant-1',
      name: 'Classic Burger',
      price: 7.5,
    );

    final item = CartItemModel.fromProduct(product, quantity: 3);

    expect(item.productId, 'burger-1');
    expect(item.quantity, 3);
    expect(item.total, 22.5);
  });
}
