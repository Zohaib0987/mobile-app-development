import 'package:flutter/foundation.dart';
import 'package:pizzahut/models/cart_item.dart';
import 'package:pizzahut/models/pizza.dart';
import 'package:pizzahut/services/cart_service.dart' as service;
import 'package:pizzahut/services/local_storage_service.dart';

class CartProvider with ChangeNotifier {
  final LocalStorageService _storage;
  final service.CartService _cartService;
  List<CartItem> _items = [];

  CartProvider(LocalStorageService storage)
      : _storage = storage,
        _cartService = service.CartService(storage) {
    _loadCartItems();
  }

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get itemCount => _items.length;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.1; // 10% tax
  double get deliveryFee => 5.0;
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> _loadCartItems() async {
    try {
      _items = await _cartService.getCartItems();
      notifyListeners();
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  Future<void> addItem(Pizza pizza, int quantity, String size, String crust,
      List<String> toppings, double totalPrice) async {
    try {
      await _cartService.addToCart(
        pizza,
        quantity,
        size,
        crust,
        toppings,
        totalPrice,
      );
      await _loadCartItems();
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> removeItem(String cartItemId) async {
    try {
      await _cartService.removeFromCart(cartItemId);
      await _loadCartItems();
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      await _cartService.updateQuantity(cartItemId, quantity);
      await _loadCartItems();
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> clear() async {
    try {
      await _cartService.clearCart();
      await _loadCartItems();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}
