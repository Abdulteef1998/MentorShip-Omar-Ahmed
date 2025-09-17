// lib/ui/screens/dashboard_screen.dart
import 'package:flutter/material.dart';

import '../../models/order.dart';

class DashboardScreen extends StatelessWidget {
  final List<Order> orders;

  const DashboardScreen({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalOrders = orders.length;

    // حساب المشروب الأكثر مبيعًا
    final drinkCounts = <DrinkType, int>{};
    for (var order in orders) {
      drinkCounts[order.drink] = (drinkCounts[order.drink] ?? 0) + 1;
    }
    DrinkType? topDrink;
    if (drinkCounts.isNotEmpty) {
      topDrink = drinkCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Orders: $totalOrders',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Top Drink: ${topDrink != null ? topDrink.name : "N/A"}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Recent Orders:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: orders.isEmpty
                  ? const Center(child: Text('No orders available'))
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return ListTile(
                          title: Text(order.customerName),
                          subtitle: Text(order.drink.name),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
