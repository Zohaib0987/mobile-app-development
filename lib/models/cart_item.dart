import 'package:pizzahut/models/pizza.dart';

class CartItem {
  final String id;
  final Pizza pizza;
  final int quantity;
  final String size;
  final String crust;
  final List<String> toppings;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.pizza,
    required this.quantity,
    required this.size,
    required this.crust,
    required this.toppings,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pizzaId': pizza.id,
      'quantity': quantity,
      'size': size,
      'crust': crust,
      'toppings': toppings,
      'totalPrice': totalPrice,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, Pizza pizza) {
    return CartItem(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      pizza: pizza,
      quantity: map['quantity'] as int,
      size: map['size'] as String,
      crust: map['crust'] as String,
      toppings: List<String>.from(map['toppings'] as List),
      totalPrice: (map['totalPrice'] as num).toDouble(),
    );
  }
}
