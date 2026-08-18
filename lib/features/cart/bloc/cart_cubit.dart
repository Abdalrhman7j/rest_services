import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/cart_item_model.dart';
import '../data/repositories/cart_repository.dart';

class CartState {
  const CartState({this.items = const [], this.isLoading = true, this.error});

  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  int get count => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository) : super(const CartState());

  final CartRepository _repository;
  StreamSubscription<List<CartItemModel>>? _subscription;

  void start() {
    _subscription = _repository.watchItems().listen(
      (items) => emit(CartState(items: items, isLoading: false)),
      onError: (_) => emit(const CartState(isLoading: false, error: 'Could not load your cart.')),
    );
  }

  Future<void> add(CartItemModel item) {
    final hasAnotherRestaurant = state.items.any(
      (existing) => existing.restaurantId != item.restaurantId,
    );
    if (hasAnotherRestaurant) {
      throw StateError('Complete or empty your current cart before ordering from another restaurant.');
    }
    return _repository.add(item);
  }

  Future<void> changeQuantity(CartItemModel item, int quantity) =>
      _repository.changeQuantity(item, quantity);

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
