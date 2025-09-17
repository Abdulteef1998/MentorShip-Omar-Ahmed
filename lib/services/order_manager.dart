import '../models/order.dart';
import '../repositories/order_repository.dart';

class OrderManager {
  final OrderRepository repository;

  OrderManager(this.repository);

  Future<void> addOrder({
    required String customerName,
    required DrinkType drink,
    String instructions = '',
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final order = Order(
      id: id,
      customerName: customerName.isEmpty ? 'Guest' : customerName,
      drink: drink,
      instructions: instructions,
    );
    await repository.addOrder(order);
  }

  Future<void> markOrderComplete(Order order) async {
    final updated = order.markComplete();
    await repository.updateOrder(updated);
  }

  Future<List<Order>> getPendingOrders() async {
    final all = await repository.getAllOrders();
    return all.where((o) => !o.completed).toList();
  }

  Future<List<Order>> getAllOrders() => repository.getAllOrders();
}
