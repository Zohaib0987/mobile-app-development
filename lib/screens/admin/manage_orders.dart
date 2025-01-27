import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pizzahut/services/local_storage_service.dart';
import 'package:pizzahut/services/order_service.dart';
import 'package:pizzahut/models/order.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final storage = context.read<LocalStorageService>();
      final orderService = OrderService(storage);
      final orders = await orderService.getOrders();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading orders: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateOrderStatus(Order order, String newStatus) async {
    try {
      final storage = context.read<LocalStorageService>();
      final orderService = OrderService(storage);
      await orderService.updateOrderStatus(order.id, newStatus);
      await _loadOrders();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order status updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating order status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }

    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('Order #${order.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${order.status}'),
                Text('Total: \$${order.total}'),
                Text('Date: ${order.createdAt.toString()}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (String status) => _updateOrderStatus(order, status),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                const PopupMenuItem<String>(
                  value: 'confirmed',
                  child: Text('Confirmed'),
                ),
                const PopupMenuItem<String>(
                  value: 'preparing',
                  child: Text('Preparing'),
                ),
                const PopupMenuItem<String>(
                  value: 'on_the_way',
                  child: Text('On the Way'),
                ),
                const PopupMenuItem<String>(
                  value: 'delivered',
                  child: Text('Delivered'),
                ),
                const PopupMenuItem<String>(
                  value: 'cancelled',
                  child: Text('Cancelled'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
