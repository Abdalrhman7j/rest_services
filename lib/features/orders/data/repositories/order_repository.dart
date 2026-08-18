import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../cart/data/models/cart_item_model.dart';

class OrderRepository {
  OrderRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> createOrder({
    required String userId,
    required List<CartItemModel> items,
    required String deliveryAddress,
  }) async {
    if (items.isEmpty) throw StateError('Your cart is empty.');
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.total);
    final deliveryFee = subtotal >= 20 ? 0.0 : 2.0;
    final order = _firestore.collection('orders').doc();
    final batch = _firestore.batch();
    batch.set(order, {
      'customerId': userId,
      'restaurantId': items.first.restaurantId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': subtotal + deliveryFee,
      'deliveryAddress': deliveryAddress.trim(),
      'status': 'awaiting_restaurant',
      'createdAt': FieldValue.serverTimestamp(),
    });
    for (final item in items) {
      batch.delete(_firestore.collection('carts').doc(userId).collection('items').doc(item.productId));
    }
    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
