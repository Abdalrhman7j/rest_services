import 'package:flutter/material.dart';

import '../../data/models/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({required this.restaurant, required this.onTap, super.key});

  final RestaurantModel restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.orange,
                child: restaurant.imageUrl.isEmpty
                    ? const Icon(Icons.restaurant, color: Colors.white, size: 70)
                    : Image.network(restaurant.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.restaurant, color: Colors.white, size: 70)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurant.name, style: Theme.of(context).textTheme.titleLarge),
                    if (restaurant.description.isNotEmpty) ...[const SizedBox(height: 4), Text(restaurant.description)],
                    const SizedBox(height: 10),
                    Row(children: [const Icon(Icons.star, color: Colors.orange), const SizedBox(width: 4), Text(restaurant.rating.toStringAsFixed(1)), const SizedBox(width: 16), const Icon(Icons.timer_outlined), const SizedBox(width: 4), Text('${restaurant.deliveryTime} min')]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
