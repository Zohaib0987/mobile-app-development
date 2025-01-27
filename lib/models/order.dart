import 'package:pizzahut/models/cart_item.dart';
import 'package:pizzahut/models/pizza.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final String address;
  final String phone;
  final String? note;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.address,
    required this.phone,
    this.note,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'address': address,
      'phone': phone,
      'note': note,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Order.fromMap(
      Map<String, dynamic> map, List<Map<String, dynamic>> pizzas) {
    return Order(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: (map['items'] as List<dynamic>).map((item) {
        final pizzaId = item['pizzaId'] as String;
        final pizzaMap = pizzas.firstWhere(
          (p) => p['id'] == pizzaId,
          orElse: () => throw Exception('Pizza not found'),
        );
        return CartItem.fromMap(
          Map<String, dynamic>.from(item as Map),
          Pizza.fromJson(pizzaMap),
        );
      }).toList(),
      total: (map['total'] as num).toDouble(),
      address: map['address'] as String,
      phone: map['phone'] as String,
      note: map['note'] as String?,
      paymentMethod: map['paymentMethod'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
