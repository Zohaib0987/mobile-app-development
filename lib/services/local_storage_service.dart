import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pizzahut/models/pizza.dart';
import 'package:pizzahut/models/order.dart';
import 'package:pizzahut/models/cart_item.dart';

class LocalStorageService {
  final SharedPreferences _prefs;
  static const String _userKey = 'user';
  static const String _usersKey = 'users';
  static const String _cartKey = 'cart';
  static const String _ordersKey = 'orders';
  static const String _pizzasKey = 'pizzas';

  LocalStorageService(this._prefs);

  // User Management
  Future<Map<String, dynamic>?> getUser() async {
    final userStr = _prefs.getString(_userKey);
    if (userStr == null) return null;
    return json.decode(userStr) as Map<String, dynamic>;
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    // Also save to users list if not exists
    final users = await getAllUsers() ?? [];
    if (!users.any((u) => u['id'] == user['id'])) {
      users.add({
        ...user,
        'createdAt': DateTime.now().toIso8601String(),
      });
      await _prefs.setString(_usersKey, json.encode(users));
    }
    await _prefs.setString(_userKey, json.encode(user));
  }

  Future<void> removeUser() async {
    await _prefs.remove(_userKey);
  }

  Future<List<Map<String, dynamic>>?> getAllUsers() async {
    final usersStr = _prefs.getString(_usersKey);
    if (usersStr == null) return null;
    final List<dynamic> decoded = json.decode(usersStr);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final users = await getAllUsers() ?? [];
    final index = users.indexWhere((u) => u['id'] == user['id']);
    if (index != -1) {
      users[index] = user;
      await _prefs.setString(_usersKey, json.encode(users));

      // Update current user if it's the same
      final currentUser = await getUser();
      if (currentUser != null && currentUser['id'] == user['id']) {
        await _prefs.setString(_userKey, json.encode(user));
      }
    }
  }

  Future<void> deleteUser(String userId) async {
    final users = await getAllUsers() ?? [];
    users.removeWhere((u) => u['id'] == userId);
    await _prefs.setString(_usersKey, json.encode(users));

    // Remove current user if it's the same
    final currentUser = await getUser();
    if (currentUser != null && currentUser['id'] == userId) {
      await removeUser();
    }
  }

  // Cart Management
  Future<List<Map<String, dynamic>>?> getCartItems() async {
    final cartStr = _prefs.getString(_cartKey);
    if (cartStr == null) return null;
    final List<dynamic> decoded = json.decode(cartStr);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveCartItems(List<Map<String, dynamic>> items) async {
    await _prefs.setString(_cartKey, json.encode(items));
  }

  // Order Management
  Future<List<Map<String, dynamic>>?> getOrders() async {
    final ordersStr = _prefs.getString(_ordersKey);
    if (ordersStr == null) return null;
    final List<dynamic> decoded = json.decode(ordersStr);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveOrders(List<Map<String, dynamic>> orders) async {
    await _prefs.setString(_ordersKey, json.encode(orders));
  }

  // Pizza Management
  Future<List<Map<String, dynamic>>?> getPizzas() async {
    final pizzasStr = _prefs.getString(_pizzasKey);
    if (pizzasStr == null) return null;
    final List<dynamic> decoded = json.decode(pizzasStr);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> savePizzas(List<Map<String, dynamic>> pizzas) async {
    await _prefs.setString(_pizzasKey, json.encode(pizzas));
  }

  Future<String?> getUserId() async {
    final user = await getUser();
    return user?['id'] as String?;
  }
}
