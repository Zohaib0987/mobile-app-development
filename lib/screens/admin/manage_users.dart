import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pizzahut/services/local_storage_service.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final storage = context.read<LocalStorageService>();
      final user = await storage.getUser();
      if (user != null && user['role'] == 'admin') {
        // For demo purposes, we'll just show the current user
        _users = [user];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading users: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    try {
      final storage = context.read<LocalStorageService>();
      await storage.removeUser();
      setState(() {
        _users.removeWhere((u) => u['id'] == user['id']);
      });
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          title: Text(user['name'] ?? 'Unknown'),
          subtitle: Text(user['email'] ?? 'No email'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteUser(user),
          ),
        );
      },
    );
  }
}
