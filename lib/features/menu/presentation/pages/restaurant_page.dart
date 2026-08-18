import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/bloc/cart_cubit.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../home/data/models/restaurant_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/menu_repository.dart';

class RestaurantPage extends StatelessWidget {
  RestaurantPage({required this.restaurant, super.key});

  final RestaurantModel restaurant;
  final MenuRepository _repository = MenuRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      body: StreamBuilder<List<ProductModel>>(
        stream: _repository.watchProducts(restaurant.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Could not load this menu.'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final products = snapshot.data!;
          if (products.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('This restaurant has no available items yet.')));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _ProductTile(product: products[index]),
          );
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(12)), child: product.imageUrl.isEmpty ? const Icon(Icons.fastfood) : Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.fastfood))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.name, style: Theme.of(context).textTheme.titleMedium), if (product.description.isNotEmpty) ...[const SizedBox(height: 4), Text(product.description)], const SizedBox(height: 6), Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))])),
            IconButton(
              tooltip: 'Add to cart',
              onPressed: product.isAvailable
                  ? () async {
                      try {
                        await context.read<CartCubit>().add(CartItemModel.fromProduct(product));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart.')));
                        }
                      } on StateError catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
                        }
                      }
                    }
                  : null,
              icon: const Icon(Icons.add_circle, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
