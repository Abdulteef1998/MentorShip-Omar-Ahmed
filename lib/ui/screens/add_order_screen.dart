// lib/screens/add_order_screen.dart
import 'package:flutter/material.dart';
import 'package:mentorship_omar_ahmed/models/order.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({Key? key}) : super(key: key);

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _customerName = '';
  DrinkType _selectedDrink = DrinkType.shai;
  String _instructions = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerName: _customerName,
        drink: _selectedDrink,
        instructions: _instructions,
      );
      Navigator.pop(context, order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Order')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
                onSaved: (value) => _customerName = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<DrinkType>(
                value: _selectedDrink,
                decoration: const InputDecoration(labelText: 'Drink'),
                items: DrinkType.values.map((drink) {
                  return DropdownMenuItem(
                    value: drink,
                    child: Text(drink.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDrink = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Instructions'),
                onSaved: (value) => _instructions = value ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
