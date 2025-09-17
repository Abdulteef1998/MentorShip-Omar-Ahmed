// lib/main.dart
import 'package:flutter/material.dart';

import 'models/order.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/orders_screen.dart';

void main() {
  runApp(const AhwaApp());
}

class AhwaApp extends StatelessWidget {
  const AhwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Ahwa Manager',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const OrdersScreen(orders: []),
      routes: {
        '/dashboard': (context) {
          final orders =
              ModalRoute.of(context)!.settings.arguments as List<Order>;
          return DashboardScreen(orders: orders);
        },
      },
    );
  }
}
