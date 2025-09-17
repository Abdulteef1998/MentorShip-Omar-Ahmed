import '../models/order.dart';
import '../repositories/order_repository.dart';

class SalesReport {
  final Map<DrinkType, int> counts;
  final int totalOrders;

  SalesReport(this.counts, this.totalOrders);
}

class ReportGenerator {
  final OrderRepository repository;
  ReportGenerator(this.repository);

  Future<SalesReport> generate() async {
    final all = await repository.getAllOrders();
    final counts = <DrinkType, int>{};
    for (final dt in DrinkType.values) {
      counts[dt] = 0;
    }
    for (final o in all) {
      counts[o.drink] = (counts[o.drink] ?? 0) + 1;
    }
    return SalesReport(counts, all.length);
  }
}
