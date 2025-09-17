// lib/ui/screens/orders_screen.dart
import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../widgets/order_card.dart';
import 'add_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key, required List orders}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Order> _orders = [];

  void _addOrder(Order order) {
    setState(() {
      _orders.add(order);
    });
  }

  void _removeOrder(String id) {
    setState(() {
      _orders.removeWhere((order) => order.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ahwa Smart Cafe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard', arguments: _orders);
            },
          ),
        ],
      ),
      body: _orders.isEmpty
          ? const Center(child: Text('No orders yet.'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Dismissible(
                  key: Key(order.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    _removeOrder(order.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${order.customerName} deleted')),
                    );
                  },
                  child: OrderCard(order: order, onTap: () {}),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newOrder = await Navigator.push<Order>(
            context,
            MaterialPageRoute(builder: (_) => AddOrderScreen()),
          );
          if (newOrder != null) {
            _addOrder(newOrder);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
