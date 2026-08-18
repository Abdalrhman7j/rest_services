import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant_model.dart';

class HomeRepository {
  HomeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<RestaurantModel>> getRestaurants() async {
    final snapshot = await _firestore.collection('restaurants').get();
    final restaurants = snapshot.docs
        .map((document) => RestaurantModel.fromMap(document.id, document.data()))
        .toList();
    restaurants.sort((a, b) => a.name.compareTo(b.name));
    return restaurants;
  }
}
