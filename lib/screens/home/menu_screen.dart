import 'package:flutter/material.dart';
import 'package:pizzahut/models/pizza.dart';
import 'package:pizzahut/screens/home/pizza_details_screen.dart';
import 'package:pizzahut/data/pizzas.dart';
import 'package:pizzahut/widgets/pizza_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Pizza> _pizzas = samplePizzas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _pizzas.length,
        itemBuilder: (context, index) {
          final pizza = _pizzas[index];
          return PizzaCard(
            pizza: pizza,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PizzaDetailsScreen(pizza: pizza),
                  ),
                );
              },
          );
        },
      ),
    );
  }
}
