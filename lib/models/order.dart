import 'package:flutter/foundation.dart';

enum DrinkType { shai, turkishCoffee, hibiscusTea }

extension DrinkTypeX on DrinkType {
  String get displayName {
    switch (this) {
      case DrinkType.shai:
        return 'Shai (Tea)';
      case DrinkType.turkishCoffee:
        return 'Turkish Coffee';
      case DrinkType.hibiscusTea:
        return 'Hibiscus Tea';
    }
  }

  String get imagePath {
    switch (this) {
      case DrinkType.shai:
        return 'assets/images/tea.png';
      case DrinkType.turkishCoffee:
        return 'assets/images/coffee.png';
      case DrinkType.hibiscusTea:
        return 'assets/images/hibiscus.png';
    }
  }
}

@immutable
class Order {
  final String id;
  final String customerName;
  final DrinkType drink;
  final String instructions;
  final DateTime createdAt;
  final bool completed;

  Order({
    required this.id,
    required this.customerName,
    required this.drink,
    this.instructions = '',
    DateTime? createdAt,
    this.completed = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Order markComplete() {
    return Order(
      id: id,
      customerName: customerName,
      drink: drink,
      instructions: instructions,
      createdAt: createdAt,
      completed: true,
    );
  }

  Order copyWith({
    String? customerName,
    DrinkType? drink,
    String? instructions,
    bool? completed,
  }) {
    return Order(
      id: id,
      customerName: customerName ?? this.customerName,
      drink: drink ?? this.drink,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt,
      completed: completed ?? this.completed,
    );
  }
}
