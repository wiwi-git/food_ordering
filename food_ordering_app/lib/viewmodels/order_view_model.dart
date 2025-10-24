
import 'package:flutter/foundation.dart';
import '../models/food.dart';

// A single item in the cart
class CartItem {
  final Food food;
  int quantity;

  CartItem({required this.food, this.quantity = 0});
}

class OrderViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.food.price * item.quantity));

  // Initialize items from a list of foods
  void init(List<Food> foods) {
    _items.clear();
    for (var food in foods) {
      _items.add(CartItem(food: food));
    }
    notifyListeners();
  }

  // Increment the quantity of a food item
  void increment(Food food) {
    final item = _items.firstWhere((item) => item.food.name == food.name);
    if (item.quantity < 9) {
      item.quantity++;
      notifyListeners();
    }
  }

  // Decrement the quantity of a food item
  void decrement(Food food) {
    final item = _items.firstWhere((item) => item.food.name == food.name);
    if (item.quantity > 0) {
      item.quantity--;
      notifyListeners();
    }
  }

  // Get a list of items that have been added to the cart (quantity > 0)
  List<CartItem> get cartItems => _items.where((item) => item.quantity > 0).toList();

  // Reset the entire order
  void reset() {
    for (var item in _items) {
      item.quantity = 0;
    }
    notifyListeners();
  }

  // Simulate placing an order
  Future<void> placeOrder() async {
    _isLoading = true;
    notifyListeners();

    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }
}
