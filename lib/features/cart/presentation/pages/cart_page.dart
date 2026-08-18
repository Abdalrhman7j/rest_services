import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../orders/data/repositories/order_repository.dart';
import '../../bloc/cart_cubit.dart';
import '../../data/models/cart_item_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({required this.userId, super.key});

  final String userId;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _addressController = TextEditingController();
  final _repository = OrderRepository();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _checkout(CartState cart) async {
    if (_addressController.text.trim().length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a delivery address.')));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await _repository.createOrder(userId: widget.userId, items: cart.items, deliveryAddress: _addressController.text);
      if (mounted) {
        _addressController.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your order has been placed.')));
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not place the order. Please try again.')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Your cart')),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, cart) {
            if (cart.isLoading) return const Center(child: CircularProgressIndicator());
            if (cart.error != null) return Center(child: Text(cart.error!));
            if (cart.items.isEmpty) return const _EmptyCart();
            final deliveryFee = cart.subtotal >= 20 ? 0.0 : 2.0;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...cart.items.map((item) => _CartItemTile(item: item)),
                const Divider(height: 32),
                TextField(controller: _addressController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Delivery address', hintText: 'Street, building, area', border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on_outlined))),
                const SizedBox(height: 20),
                _PriceRow(label: 'Subtotal', value: cart.subtotal),
                _PriceRow(label: 'Delivery', value: deliveryFee),
                const Divider(),
                _PriceRow(label: 'Total', value: cart.subtotal + deliveryFee, emphasized: true),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : () => _checkout(cart),
                  icon: _isSubmitting ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check_circle_outline),
                  label: Text(_isSubmitting ? 'Placing order...' : 'Place order'),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
                const SizedBox(height: 8),
                const Text('Payment method: cash on delivery', textAlign: TextAlign.center),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('\$${item.unitPrice.toStringAsFixed(2)} each'),
        trailing: SizedBox(
          width: 116,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () => context.read<CartCubit>().changeQuantity(item, item.quantity - 1), icon: const Icon(Icons.remove_circle_outline)),
              Text('${item.quantity}'),
              IconButton(onPressed: () => context.read<CartCubit>().changeQuantity(item, item.quantity + 1), icon: const Icon(Icons.add_circle_outline)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.emphasized = false});

  final String label;
  final double value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: style), Text('\$${value.toStringAsFixed(2)}', style: style)]),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 72, color: Colors.grey),
          SizedBox(height: 12),
          Text('Your cart is empty.'),
          SizedBox(height: 4),
          Text('Add items from a restaurant to place an order.'),
        ],
      ),
    );
  }
}
