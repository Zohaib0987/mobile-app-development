import 'package:flutter/foundation.dart';
import 'package:pizzahut/services/local_storage_service.dart';
import 'package:pizzahut/providers/cart_provider.dart';

class AuthProvider with ChangeNotifier {
  final LocalStorageService _storage;
  Map<String, dynamic>? _user;
  static const _adminEmail = 'zohaib@admin.com';
  static const _adminPassword = '123456';

  AuthProvider(this._storage) {
    _loadUser();
  }

  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user != null && _user!['role'] == 'admin';
  Map<String, dynamic>? get user => _user;

  Future<void> _loadUser() async {
    print('Loading user from storage');
    _user = await _storage.getUser();
    print('Loaded user: $_user');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    print('Attempting login with email: $email');

    // Simple email/password validation
    if (!email.contains('@') || password.length < 6) {
      throw 'Invalid email or password';
    }

    // Check if admin credentials
    if (email == _adminEmail && password == _adminPassword) {
      print('Admin credentials matched');
      _user = {
        'id': 'admin',
        'email': email,
        'name': 'Admin',
        'role': 'admin',
      };
      print('Admin user set: $_user');
    } else {
      print('Regular user login');
      _user = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': email,
        'name': email.split('@')[0],
        'role': 'user',
      };
    }

    // Save user and wait for it to complete
    print('Saving user to storage');
    await _storage.saveUser(_user!);

    // Load the user from storage to ensure consistency
    print('Reloading user from storage');
    await _loadUser();

    print('Login completed. User: $_user, isAdmin: $isAdmin');
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simple validation
    if (name.isEmpty || !email.contains('@') || password.length < 6) {
      throw 'Invalid registration details';
    }

    // Don't allow registration with admin email
    if (email == _adminEmail) {
      throw 'This email is reserved';
    }

    _user = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'role': 'user',
    };

    await _storage.saveUser(_user!);
    notifyListeners();
  }

  Future<void> logout() async {
    print('Logging out');
    try {
      await _storage.removeUser();
      _user = null;
      notifyListeners();
      print('Logout completed');
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  // Add method to clear all user data
  Future<void> clearUserData(CartProvider cartProvider) async {
    await logout();
    cartProvider.clear(); // Clear the cart when logging out
  }
}
