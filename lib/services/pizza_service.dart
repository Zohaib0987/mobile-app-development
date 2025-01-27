import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzahut/models/pizza.dart';

class PizzaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Pizza>> getPizzasByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('menu_items')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((doc) => Pizza.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching pizzas: $e');
      return [];
    }
  }

  Future<List<Pizza>> getAllPizzas() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('menu_items').get();

      return snapshot.docs
          .map((doc) => Pizza.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching all pizzas: $e');
      return [];
    }
  }

  Future<Pizza?> getPizzaById(String id) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('menu_items').doc(id).get();

      if (doc.exists) {
        return Pizza.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching pizza by id: $e');
      return null;
    }
  }

  Future<void> addPizza(Pizza pizza) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(pizza.id)
          .set(pizza.toMap());
    } catch (e) {
      print('Error adding pizza: $e');
      rethrow;
    }
  }

  Future<void> updatePizza(Pizza pizza) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(pizza.id)
          .update(pizza.toMap());
    } catch (e) {
      print('Error updating pizza: $e');
      rethrow;
    }
  }

  Future<void> deletePizza(String id) async {
    try {
      await _firestore.collection('menu_items').doc(id).delete();
    } catch (e) {
      print('Error deleting pizza: $e');
      rethrow;
    }
  }

  Stream<List<Pizza>> streamPizzasByCategory(String category) {
    return _firestore
        .collection('menu_items')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Pizza.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
