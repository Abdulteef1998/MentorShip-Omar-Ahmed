import 'package:flutter/material.dart';
import 'package:mentorship_omar_ahmed/models/order.dart';
import 'package:mentorship_omar_ahmed/services/order_manager.dart';
import 'package:mentorship_omar_ahmed/services/report_generator.dart';

class AhwaHomePage extends StatefulWidget {
  final OrderManager orderManager;
  final ReportGenerator reportGenerator;

  const AhwaHomePage({
    Key? key,
    required this.orderManager,
    required this.reportGenerator,
  }) : super(key: key);

  @override
  State<AhwaHomePage> createState() => _AhwaHomePageState();
}

class _AhwaHomePageState extends State<AhwaHomePage> {
  List<Order> _pending = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final pending = await widget.orderManager.getPendingOrders();
    setState(() {
      _pending = pending;
      _loading = false;
    });
  }

  Future<void> _showAddOrderDialog() async {
    final nameCtrl = TextEditingController();
    final instrCtrl = TextEditingController();
    var selected = DrinkType.shai;

    final added = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Add Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: 'Customer name'),
              ),
              SizedBox(height: 8),
              DropdownButton<DrinkType>(
                value: selected,
                items: DrinkType.values
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(d.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (v) =>
                    setState(() => selected = v ?? DrinkType.shai),
              ),
              SizedBox(height: 8),
              TextField(
                controller: instrCtrl,
                decoration: InputDecoration(labelText: 'Instructions'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await widget.orderManager.addOrder(
                  customerName: nameCtrl.text.trim(),
                  drink: selected,
                  instructions: instrCtrl.text.trim(),
                );
                Navigator.of(ctx).pop(true);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (added == true) await _refresh();
  }

  Future<void> _markComplete(Order order) async {
    await widget.orderManager.markOrderComplete(order);
    await _refresh();
  }

  Future<void> _showReport() async {
    final report = await widget.reportGenerator.generate();
    final list = report.counts.entries
        .map((e) => '${e.key.displayName}: ${e.value}')
        .join('\n');

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sales Report'),
        content: Text(
          'Total orders: ${report.totalOrders}\n\nTop-selling:\n$list',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_loading) return Center(child: CircularProgressIndicator());
    if (_pending.isEmpty) {
      return ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No pending orders'),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      itemCount: _pending.length,
      itemBuilder: (context, i) {
        final o = _pending[i];
        return ListTile(
          title: Text('${o.customerName} — ${o.drink.displayName}'),
          subtitle: Text(o.instructions.isEmpty ? '—' : o.instructions),
          trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _markComplete(o),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Ahwa Manager'),
        actions: [
          IconButton(onPressed: _showReport, icon: Icon(Icons.bar_chart)),
        ],
      ),
      body: RefreshIndicator(onRefresh: _refresh, child: _buildList()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddOrderDialog,
      ),
    );
  }
}
