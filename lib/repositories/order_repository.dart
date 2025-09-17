import '../models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getAllOrders();
  Future<void> addOrder(Order order);
  Future<void> updateOrder(Order order);
}
