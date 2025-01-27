import 'package:flutter/foundation.dart';
import 'package:pizzahut/models/pizza.dart';
import 'package:pizzahut/services/local_storage_service.dart';

class PizzaProvider with ChangeNotifier {
  final LocalStorageService _storage;
  List<Pizza> _pizzas = [];

  PizzaProvider(this._storage) {
    _loadPizzas();
  }

  List<Pizza> get pizzas => List.unmodifiable(_pizzas);

  Future<void> _loadPizzas() async {
    final pizzasData = await _storage.getPizzas();
    if (pizzasData != null) {
      _pizzas = pizzasData.map((data) => Pizza.fromJson(data)).toList();
      notifyListeners();
    }
  }

  Future<void> addPizza(Pizza pizza) async {
    _pizzas.add(pizza);
    await _savePizzas();
    notifyListeners();
  }

  Future<void> updatePizza(Pizza pizza) async {
    final index = _pizzas.indexWhere((p) => p.id == pizza.id);
    if (index != -1) {
      _pizzas[index] = pizza;
      await _savePizzas();
      notifyListeners();
    }
  }

  Future<void> deletePizza(String id) async {
    _pizzas.removeWhere((p) => p.id == id);
    await _savePizzas();
    notifyListeners();
  }

  Future<void> _savePizzas() async {
    final pizzasData = _pizzas.map((pizza) => pizza.toJson()).toList();
    await _storage.savePizzas(pizzasData);
  }

  Pizza? getPizzaById(String id) {
    try {
      return _pizzas.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Pizza> getVegetarianPizzas() {
    return _pizzas.where((p) => p.isVeg).toList();
  }

  List<Pizza> getSpicyPizzas() {
    return _pizzas.where((p) => p.isSpicy).toList();
  }

  List<Pizza> getAvailablePizzas() {
    return _pizzas.where((p) => p.isAvailable).toList();
  }
}
