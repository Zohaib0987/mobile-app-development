import 'package:pizzahut/models/pizza.dart';
import 'package:pizzahut/services/local_storage_service.dart';
import 'package:pizzahut/models/cart_item.dart';

class CartService {
  final LocalStorageService _storage;

  CartService(this._storage);

  Future<void> addToCart(
    Pizza pizza,
    int quantity,
    String size,
    String crust,
    List<String> toppings,
    double totalPrice,
  ) async {
    try {
      final cartItems = await _storage.getCartItems() ?? [];

      cartItems.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'pizzaId': pizza.id,
        'quantity': quantity,
        'size': size,
        'crust': crust,
        'toppings': toppings,
        'totalPrice': totalPrice,
      });

      await _storage.saveCartItems(cartItems);
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      final cartItems = await _storage.getCartItems() ?? [];
      cartItems.removeWhere((item) => item['id'] == cartItemId);
      await _storage.saveCartItems(cartItems);
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      final cartItems = await _storage.getCartItems() ?? [];
      final itemIndex =
          cartItems.indexWhere((item) => item['id'] == cartItemId);

      if (itemIndex != -1) {
        cartItems[itemIndex]['quantity'] = quantity;
        await _storage.saveCartItems(cartItems);
      }
    } catch (e) {
      print('Error updating quantity: $e');
      rethrow;
    }
  }

  Future<List<CartItem>> getCartItems() async {
    try {
      final cartItems = await _storage.getCartItems() ?? [];
      final pizzas = await _storage.getPizzas() ?? [];

      return cartItems.map((item) {
        final pizza = pizzas.firstWhere(
          (p) => p['id'] == item['pizzaId'],
          orElse: () => throw Exception('Pizza not found'),
        );
        return CartItem.fromMap(
          Map<String, dynamic>.from(item),
          Pizza.fromJson(pizza),
        );
      }).toList();
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  Future<double> getCartTotal() async {
    try {
      final cartItems = await _storage.getCartItems() ?? [];
      double total = 0.0;
      for (var item in cartItems) {
        total += (item['totalPrice'] as num).toDouble();
      }
      return total;
    } catch (e) {
      print('Error calculating cart total: $e');
      return 0;
    }
  }

  Future<void> clearCart() async {
    try {
      await _storage.saveCartItems([]);
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }
}
