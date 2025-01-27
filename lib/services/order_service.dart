import 'package:pizzahut/services/local_storage_service.dart';
import 'package:pizzahut/models/cart_item.dart';
import 'package:pizzahut/models/order.dart';

class OrderService {
  final LocalStorageService _storage;

  OrderService(this._storage);

  Future<void> createOrder({
    required List<CartItem> items,
    required double total,
    required String address,
    required String phone,
    String? note,
    required String paymentMethod,
  }) async {
    try {
      final userId = await _storage.getUserId();
      if (userId == null) {
        throw 'User not authenticated';
      }

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        items: items,
        total: total,
        address: address,
        phone: phone,
        note: note,
        paymentMethod: paymentMethod,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      final orders = await _storage.getOrders() ?? [];
      orders.add(order.toMap());
      await _storage.saveOrders(orders);
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final userId = await _storage.getUserId();
      if (userId == null) {
        return [];
      }

      final orders = await _storage.getOrders() ?? [];
      final pizzas = await _storage.getPizzas() ?? [];

      return orders
          .where((order) => order['userId'] == userId)
          .map((order) => Order.fromMap(order, pizzas))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final orders = await _storage.getOrders() ?? [];
      final pizzas = await _storage.getPizzas() ?? [];
      final orderMap = orders.firstWhere(
        (order) => order['id'] == orderId,
        orElse: () => throw Exception('Order not found'),
      );
      return Order.fromMap(orderMap, pizzas);
    } catch (e) {
      print('Error getting order: $e');
      return null;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final orders = await _storage.getOrders() ?? [];
      final orderIndex = orders.indexWhere((order) => order['id'] == orderId);

      if (orderIndex != -1) {
        orders[orderIndex]['status'] = status;
        await _storage.saveOrders(orders);
      }
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }
}
