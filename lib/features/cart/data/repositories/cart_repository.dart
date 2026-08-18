import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item_model.dart';

class CartRepository {
  CartRepository({required this.userId, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String userId;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection('carts').doc(userId).collection('items');

  Stream<List<CartItemModel>> watchItems() => _items.snapshots().map(
        (snapshot) => snapshot.docs
            .map((document) => CartItemModel.fromMap(document.data()))
            .toList(),
      );

  Future<void> add(CartItemModel item) {
    final reference = _items.doc(item.productId);
    return _firestore.runTransaction((transaction) async {
      final current = await transaction.get(reference);
      final quantity = current.exists
          ? (current.data()?['quantity'] as num? ?? 0).toInt() + item.quantity
          : item.quantity;
      transaction.set(reference, {...item.toMap(), 'quantity': quantity});
    });
  }

  Future<void> changeQuantity(CartItemModel item, int quantity) {
    final reference = _items.doc(item.productId);
    return quantity <= 0 ? reference.delete() : reference.update({'quantity': quantity});
  }
}
