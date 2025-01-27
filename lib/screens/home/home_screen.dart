import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pizzahut/models/pizza.dart';
import 'package:pizzahut/providers/auth_provider.dart';
import 'package:pizzahut/providers/cart_provider.dart';
import 'package:pizzahut/providers/pizza_provider.dart';
import 'package:pizzahut/screens/admin/admin_screen.dart';
import 'package:pizzahut/screens/cart/cart_screen.dart';
import 'package:pizzahut/widgets/pizza_card.dart';
import 'package:pizzahut/widgets/cart_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedSize = 'Medium';
  String _selectedCrust = 'Hand Tossed';
  final List<String> _selectedToppings = [];
  int _quantity = 1;

  final List<String> _sizes = ['Small', 'Medium', 'Large'];
  final List<String> _crusts = ['Hand Tossed', 'Thin', 'Pan', 'Stuffed'];
  final List<String> _availableToppings = [
    'Extra Cheese',
    'Pepperoni',
    'Mushrooms',
    'Onions',
    'Sausage',
    'Black Olives',
    'Green Peppers',
    'Pineapple',
    'Bacon',
    'Chicken',
  ];

  void _showCustomizeDialog(BuildContext context, Pizza pizza) {
    setState(() {
      _selectedSize = 'Medium';
      _selectedCrust = 'Hand Tossed';
      _selectedToppings.clear();
      _quantity = 1;
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          double basePrice = pizza.price;
          if (_selectedSize == 'Small') basePrice *= 0.8;
          if (_selectedSize == 'Large') basePrice *= 1.2;
          if (_selectedCrust == 'Stuffed') basePrice += 2;
          if (_selectedCrust == 'Pan') basePrice += 1;
          basePrice += _selectedToppings.length * 0.5;
          final totalPrice = basePrice * _quantity;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: 400,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Customize ${pizza.name}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Size',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _sizes.map((size) {
                              return ChoiceChip(
                                label: Text(size),
                                selected: _selectedSize == size,
                                onSelected: (selected) {
                                  setState(() => _selectedSize = size);
                                },
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: _selectedSize == size
                                      ? Colors.white
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Crust',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _crusts.map((crust) {
                              return ChoiceChip(
                                label: Text(crust),
                                selected: _selectedCrust == crust,
                                onSelected: (selected) {
                                  setState(() => _selectedCrust = crust);
                                },
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: _selectedCrust == crust
                                      ? Colors.white
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Extra Toppings',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _availableToppings.map((topping) {
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
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: _selectedToppings.contains(topping)
                                      ? Colors.white
                                      : null,
                                ),
                                checkmarkColor: Colors.white,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: _quantity > 1
                                          ? () {
                                              setState(() => _quantity--);
                                            }
                                          : null,
                                    ),
                                    Text(
                                      '$_quantity',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() => _quantity++);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '\$${totalPrice.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: () {
                          final cart = context.read<CartProvider>();
                          cart.addItem(
                            pizza,
                            _quantity,
                            _selectedSize,
                            _selectedCrust,
                            List<String>.from(_selectedToppings),
                            totalPrice,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Added to cart!'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 600 && screenWidth <= 1200;
    final horizontalPadding = isDesktop ? 80.0 : (isTablet ? 40.0 : 16.0);
    final maxCrossAxisExtent = isDesktop ? 400.0 : (isTablet ? 300.0 : 280.0);

    if (auth.isAdmin) {
      return const AdminScreen();
    }

    return Consumer<PizzaProvider>(
      builder: (context, pizzaProvider, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: !isDesktop,
            leadingWidth: isDesktop ? horizontalPadding : null,
            leading: isDesktop ? const SizedBox() : null,
            title: Text(
              'Pizza Hut',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            actions: [
              const CartButton(),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final auth = context.read<AuthProvider>();
                  final cartProvider = context.read<CartProvider>();
                  await auth.clearUserData(cartProvider);
                  if (!mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
              SizedBox(width: isDesktop ? (horizontalPadding - 8) : 8),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 1400 : double.infinity,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: isDesktop ? 40 : 16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: isDesktop
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign:
                                isDesktop ? TextAlign.center : TextAlign.start,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose from our premium selection of pizzas',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                            textAlign:
                                isDesktop ? TextAlign.center : TextAlign.start,
                          ),
                          if (isDesktop) const SizedBox(height: 40),
                          if (!isDesktop) const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: maxCrossAxisExtent,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final pizza = pizzaProvider.pizzas[index];
                          return PizzaCard(
                            pizza: pizza,
                            onTap: () => _showCustomizeDialog(context, pizza),
                          );
                        },
                        childCount: pizzaProvider.pizzas.length,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: isDesktop ? 40 : 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
