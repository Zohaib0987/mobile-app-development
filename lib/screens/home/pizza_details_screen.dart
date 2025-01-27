import 'package:flutter/material.dart';
import 'package:pizzahut/models/pizza.dart';
import 'package:provider/provider.dart';
import 'package:pizzahut/providers/cart_provider.dart';

class PizzaDetailsScreen extends StatefulWidget {
  final Pizza pizza;

  const PizzaDetailsScreen({super.key, required this.pizza});

  @override
  State<PizzaDetailsScreen> createState() => _PizzaDetailsScreenState();
}

class _PizzaDetailsScreenState extends State<PizzaDetailsScreen> {
  late String _selectedSize;
  late String _selectedCrust;
  int _quantity = 1;
  final List<String> _selectedToppings = [];

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.pizza.sizes.first;
    _selectedCrust = widget.pizza.crusts.first;
  }

  double get _totalPrice {
    double basePrice = widget.pizza.price;
    // Add size price
    if (_selectedSize == 'Medium') basePrice += 2;
    if (_selectedSize == 'Large') basePrice += 4;
    // Add crust price
    if (_selectedCrust == 'Thick') basePrice += 1;
    // Add toppings price ($0.50 per topping)
    basePrice += _selectedToppings.length * 0.5;
    // Multiply by quantity
    return basePrice * _quantity;
  }

  void _addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(
      widget.pizza,
      _quantity,
      _selectedSize,
      _selectedCrust,
      _selectedToppings,
      _totalPrice / _quantity, // price per item
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pizza.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pizza Image
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Hero(
                      tag: 'pizza-${widget.pizza.id}',
                      child: Image.network(
                        widget.pizza.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: const Icon(Icons.local_pizza, size: 64),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pizza Name and Badges
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.pizza.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.pizza.isVeg)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Vegetarian',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (widget.pizza.isSpicy)
                              const Chip(
                                label: Text('Spicy'),
                                avatar: Icon(Icons.whatshot, color: Colors.red),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Description
                        Text(
                          widget.pizza.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        // Size Selection
                        const Text(
                          'Size',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: widget.pizza.sizes.map((size) {
                            return ChoiceChip(
                              label: Text(size),
                              selected: _selectedSize == size,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedSize = size);
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Crust Selection
                        const Text(
                          'Crust',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: widget.pizza.crusts.map((crust) {
                            return ChoiceChip(
                              label: Text(crust),
                              selected: _selectedCrust == crust,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedCrust = crust);
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Extra Toppings
                        if (widget.pizza.toppings.isNotEmpty) ...[
                          const Text(
                            'Extra Toppings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: widget.pizza.toppings.map((topping) {
                              return FilterChip(
                                label: Text(topping),
                                selected: _selectedToppings.contains(topping),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedToppings.add(topping);
                                    } else {
                                      _selectedToppings.remove(topping);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Quantity Selector
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                      ),
                      Text(
                        _quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Add to Cart Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.pizza.isAvailable ? _addToCart : null,
                    child: Text(
                      widget.pizza.isAvailable
                          ? 'Add to Cart - \$${_totalPrice.toStringAsFixed(2)}'
                          : 'Out of Stock',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
