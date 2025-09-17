import 'dart:async';

import '../models/order.dart';
import 'order_repository.dart';

class InMemoryOrderRepository implements OrderRepository {
  final List<Order> _orders = [];

  @override
  Future<void> addOrder(Order order) async {
    await Future.delayed(Duration(milliseconds: 30));
    _orders.add(order);
  }

  @override
  Future<List<Order>> getAllOrders() async {
    await Future.delayed(Duration(milliseconds: 30));
    return List.unmodifiable(_orders);
  }

  @override
  Future<void> updateOrder(Order order) async {
    await Future.delayed(Duration(milliseconds: 30));
    final idx = _orders.indexWhere((o) => o.id == order.id);
    if (idx >= 0) {
      _orders[idx] = order;
    }
  }
}
