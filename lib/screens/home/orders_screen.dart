import 'package:flutter/material.dart';

class Order {
  final String id;
  final List<OrderItem> items;
  final String status;
  final double total;
  final String address;
  final String phone;
  final String? note;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.status,
    required this.total,
    required this.address,
    required this.phone,
    this.note,
    required this.paymentMethod,
    required this.createdAt,
  });
}

class OrderItem {
  final String name;
  final String size;
  final String crust;
  final List<String> extraToppings;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.size,
    required this.crust,
    required this.extraToppings,
    required this.quantity,
    required this.price,
  });
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // TODO: Replace with actual data from Firestore
  final List<Order> _orders = [
    Order(
      id: '1',
      items: [
        OrderItem(
          name: 'Margherita',
          size: 'Medium',
          crust: 'Thin',
          extraToppings: [],
          quantity: 2,
          price: 12.99,
        ),
        OrderItem(
          name: 'Pepperoni',
          size: 'Large',
          crust: 'Regular',
          extraToppings: ['Extra Cheese'],
          quantity: 1,
          price: 14.99,
        ),
      ],
      status: 'Delivered',
      total: 40.97,
      address: '123 Main St, City, Country',
      phone: '+1234567890',
      paymentMethod: 'Credit Card',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    // Add more orders here
  ];

  String _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'FFA000'; // Amber
      case 'confirmed':
        return '1976D2'; // Blue
      case 'preparing':
        return '7B1FA2'; // Purple
      case 'on the way':
        return '0097A7'; // Cyan
      case 'delivered':
        return '388E3C'; // Green
      case 'cancelled':
        return 'D32F2F'; // Red
      default:
        return '757575'; // Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your order history will appear here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${order.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.createdAt.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    _getStatusColor(order.status),
                                    radix: 16,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                order.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Order Items
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, index) {
                          final item = order.items[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                              '${item.size} • ${item.crust}${item.extraToppings.isNotEmpty ? ' • Extra: ${item.extraToppings.join(", ")}' : ''}',
                            ),
                            trailing: Text(
                              '${item.quantity}x \$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      // Order Footer
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$${order.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Delivery Address: ${order.address}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Payment Method: ${order.paymentMethod}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
