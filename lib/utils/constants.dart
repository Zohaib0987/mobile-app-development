import 'package:pizzahut/data/pizzas.dart';

class Constants {
  static const String appName = 'Pizza Hut';
  static const String currency = '\$';
  static const double taxRate = 0.1; // 10%
  static const double deliveryFee = 5.0;

  // Default pizzas for initial app state
  static final List<Map<String, dynamic>> defaultPizzas =
      samplePizzas.map((pizza) => pizza.toJson()).toList();

  static const String placeholderPizzaImage =
      'https://images.unsplash.com/photo-1513104890138-7c749659a591';

  static const List<Map<String, dynamic>> defaultSides = [
    {
      'id': '4',
      'name': 'Garlic Breadsticks',
      'description': 'Freshly baked breadsticks with garlic butter',
      'price': 4.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1619531040576-f9416740661b',
      'category': 'Sides',
      'toppings': ['Extra Cheese', 'Marinara Sauce'],
      'sizes': ['Regular', 'Large'],
      'crusts': [],
    },
    {
      'id': '5',
      'name': 'Buffalo Wings',
      'description': 'Spicy buffalo wings with ranch dressing',
      'price': 8.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1608039755401-742074f0548d',
      'category': 'Sides',
      'toppings': ['Ranch', 'Blue Cheese'],
      'sizes': ['6 pcs', '12 pcs'],
      'crusts': [],
    },
  ];

  static const List<Map<String, dynamic>> defaultDrinks = [
    {
      'id': '6',
      'name': 'Coca-Cola',
      'description': 'Classic Coca-Cola',
      'price': 1.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1629203851122-3726ecdf080e',
      'category': 'Drinks',
      'toppings': [],
      'sizes': ['Regular', 'Large'],
      'crusts': [],
    },
    {
      'id': '7',
      'name': 'Sprite',
      'description': 'Refreshing lemon-lime soda',
      'price': 1.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3',
      'category': 'Drinks',
      'toppings': [],
      'sizes': ['Regular', 'Large'],
      'crusts': [],
    },
  ];

  static const List<Map<String, dynamic>> defaultDesserts = [
    {
      'id': '8',
      'name': 'Chocolate Chip Cookie',
      'description': 'Warm chocolate chip cookie',
      'price': 5.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e',
      'category': 'Desserts',
      'toppings': ['Ice Cream'],
      'sizes': ['Regular'],
      'crusts': [],
    },
  ];

  static List<Map<String, dynamic>> get allMenuItems => [
        ...defaultPizzas,
        ...defaultSides,
        ...defaultDrinks,
        ...defaultDesserts,
      ];
}
