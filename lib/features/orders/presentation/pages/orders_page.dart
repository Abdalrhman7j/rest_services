import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/order_repository.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({required this.userId, super.key});

  final String userId;
  final OrderRepository _repository = OrderRepository();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Your orders')),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _repository.watchOrders(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Center(child: Text('Could not load your orders.'));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final orders = snapshot.data!.docs;
            if (orders.isEmpty) return const Center(child: Text('You have not placed any orders yet.'));
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) => _OrderCard(data: orders[index].data()),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final items = (data['items'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final timestamp = data['createdAt'] as Timestamp?;
    final date = timestamp == null ? 'Just placed' : timestamp.toDate().toLocal().toString().substring(0, 16);
    final status = (data['status'] as String? ?? 'awaiting_restaurant').replaceAll('_', ' ');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(status, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)), Text(date)]),
          const SizedBox(height: 10),
          Text(items.map((item) => '${item['quantity']} x ${item['name']}').join(', ')),
          const SizedBox(height: 10),
          Text('Total: \$${(data['total'] as num? ?? 0).toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
        ]),
      ),
    );
  }
}
