import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pizzahut/services/local_storage_service.dart';
import 'package:pizzahut/providers/auth_provider.dart';
import 'package:pizzahut/providers/cart_provider.dart';
import 'package:pizzahut/providers/pizza_provider.dart';
import 'package:pizzahut/models/pizza.dart';
import 'package:pizzahut/widgets/edit_user_dialog.dart';
import 'package:pizzahut/widgets/edit_pizza_dialog.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _orders = [];
  List<Pizza> _pizzas = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final storage = context.read<LocalStorageService>();
      final pizzaProvider = context.read<PizzaProvider>();
      final users = await storage.getAllUsers() ?? [];
      final orders = await storage.getOrders() ?? [];
      setState(() {
        _users = users;
        _orders = orders;
        _pizzas = pizzaProvider.pizzas;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    try {
      final storage = context.read<LocalStorageService>();
      await storage.deleteUser(user['id']);
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  Future<void> _editUser(Map<String, dynamic> user) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditUserDialog(user: user),
    );

    if (result != null) {
      try {
        final storage = context.read<LocalStorageService>();
        await storage.updateUser(result);
        await _loadData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user: $e')),
        );
      }
    }
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      final storage = context.read<LocalStorageService>();
      final orders = await storage.getOrders() ?? [];
      final orderIndex = orders.indexWhere((order) => order['id'] == orderId);

      if (orderIndex != -1) {
        orders[orderIndex]['status'] = status;
        await storage.saveOrders(orders);
        await _loadData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order status updated successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating order status: $e')),
      );
    }
  }

  Future<void> _addPizza() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const EditPizzaDialog(),
    );

    if (result != null) {
      try {
        final pizzaProvider = context.read<PizzaProvider>();
        await pizzaProvider.addPizza(Pizza.fromJson(result));
        await _loadData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pizza added successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding pizza: $e')),
        );
      }
    }
  }

  Future<void> _editPizza(Pizza pizza) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditPizzaDialog(pizza: pizza),
    );

    if (result != null) {
      try {
        final pizzaProvider = context.read<PizzaProvider>();
        await pizzaProvider.updatePizza(Pizza.fromJson(result));
        await _loadData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pizza updated successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating pizza: $e')),
        );
      }
    }
  }

  Future<void> _deletePizza(Pizza pizza) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pizza'),
        content: Text('Are you sure you want to delete ${pizza.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final pizzaProvider = context.read<PizzaProvider>();
        await pizzaProvider.deletePizza(pizza.id);
        await _loadData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pizza deleted successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting pizza: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
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
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pizzas'),
            Tab(text: 'Users'),
            Tab(text: 'Orders'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPizzasTab(),
                _buildUsersTab(),
                _buildOrdersTab(),
              ],
            ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _addPizza,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildPizzasTab() {
    if (_pizzas.isEmpty) {
      return const Center(child: Text('No pizzas found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _pizzas.length,
      itemBuilder: (context, index) {
        final pizza = _pizzas[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  pizza.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.local_pizza, size: 64),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pizza.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editPizza(pizza),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deletePizza(pizza),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pizza.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${pizza.price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Row(
                            children: [
                              if (pizza.isVeg)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(Icons.eco,
                                      color: Colors.green, size: 20),
                                ),
                              if (pizza.isSpicy)
                                const Icon(Icons.whatshot,
                                    color: Colors.red, size: 20),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsersTab() {
    if (_users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(user['name'] ?? 'Unknown'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['email'] ?? 'No email'),
                Text('Role: ${user['role'] ?? 'user'}'),
                Text('Joined: ${DateTime.parse(user['createdAt']).toString()}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editUser(user),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUser(user),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersTab() {
    if (_orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        final user = _users.firstWhere(
          (u) => u['id'] == order['userId'],
          orElse: () => {'name': 'Unknown', 'email': 'Unknown'},
        );

        final items = List<Map<String, dynamic>>.from(order['items'] ?? []);
        final total = order['total']?.toString() ?? '0.00';
        final status = order['status'] ?? 'pending';
        final createdAt = order['createdAt'] != null
            ? DateTime.parse(order['createdAt']).toString()
            : 'Unknown date';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text('Order #${order['id'] ?? 'Unknown'}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: ${user['name']} (${user['email']})'),
                Text('Status: $status'),
                Text('Total: \$$total'),
                Text('Date: $createdAt'),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Details',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Address: ${order['address'] ?? 'No address'}'),
                    Text('Phone: ${order['phone'] ?? 'No phone'}'),
                    if (order['note'] != null &&
                        order['note'].toString().isNotEmpty)
                      Text('Note: ${order['note']}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Items',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...items.map((item) {
                      final pizza = item['pizza'] as Map<String, dynamic>?;
                      final quantity = item['quantity']?.toString() ?? '0';
                      final itemTotal =
                          item['totalPrice']?.toString() ?? '0.00';

                      return ListTile(
                        dense: true,
                        title: Text(pizza?['name'] ?? 'Unknown Pizza'),
                        subtitle: Text(
                          'Size: ${item['size'] ?? 'N/A'}, Crust: ${item['crust'] ?? 'N/A'}\n'
                          'Toppings: ${(item['toppings'] as List?)?.join(', ') ?? 'None'}',
                        ),
                        trailing: Text(
                          '$quantity x \$$itemTotal',
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Update Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: status,
                          items: const [
                            DropdownMenuItem(
                                value: 'pending', child: Text('Pending')),
                            DropdownMenuItem(
                                value: 'confirmed', child: Text('Confirmed')),
                            DropdownMenuItem(
                                value: 'preparing', child: Text('Preparing')),
                            DropdownMenuItem(
                                value: 'on_the_way', child: Text('On the way')),
                            DropdownMenuItem(
                                value: 'delivered', child: Text('Delivered')),
                            DropdownMenuItem(
                                value: 'cancelled', child: Text('Cancelled')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _updateOrderStatus(order['id'], value);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EditUserDialog extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserDialog({super.key, required this.user});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['name']);
    _emailController = TextEditingController(text: widget.user['email']);
    _selectedRole = widget.user['role'] ?? 'user';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit User',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'user', child: Text('User')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRole = value);
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    final updatedUser = {
                      ...widget.user,
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'role': _selectedRole,
                    };
                    Navigator.pop(context, updatedUser);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
