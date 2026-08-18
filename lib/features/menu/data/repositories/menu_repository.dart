import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class MenuRepository {
  MenuRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<ProductModel>> watchProducts(String restaurantId) {
    return _firestore
        .collection('products')
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) {
      final products = snapshot.docs
          .map((document) => ProductModel.fromMap(document.id, document.data()))
          .toList();
      products.sort((a, b) => a.name.compareTo(b.name));
      return products;
    });
  }
}
