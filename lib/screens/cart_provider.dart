import 'package:flutter/material.dart';
import '../models/grocery_item.dart';

class CartProvider with ChangeNotifier {
  final Map<GroceryItem, int> _items = {};

  Map<GroceryItem, int> get items => _items;

  void addItem(GroceryItem item, {int quantity = 1}) {
    if (_items.containsKey(item)) {
      _items[item] = _items[item]! + quantity;
    } else {
      _items[item] = quantity;
    }
    notifyListeners();
  }

  void removeItem(GroceryItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;

  double get totalPrice {
    return _items.entries.fold(0.0, (total, entry) {
      return total + (entry.key.price * entry.value);
    });
  }

  int get totalItems {
    return _items.values.fold(0, (total, qty) => total + qty);
  }

  int getQuantity(GroceryItem item) {
    return _items[item] ?? 0;
  }

  void updateItemQuantity(GroceryItem item, int quantity) {
    if (quantity > 0) {
      _items[item] = quantity;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void increaseQuantity(GroceryItem item) {
    if (_items.containsKey(item)) {
      _items[item] = _items[item]! + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(GroceryItem item) {
    if (_items.containsKey(item)) {
      if (_items[item]! > 1) {
        _items[item] = _items[item]! - 1;
      } else {
        _items.remove(item);
      }
      notifyListeners();
    }
  }


  List<Map<String, dynamic>> toMap() {
    return _items.entries.map((entry) {
      return {
        'id': entry.key.id,
        'name': entry.key.name,
        'price': entry.key.price,
        'quantity': entry.value,
        'imagePath': entry.key.imagePath,
        'description': entry.key.description,
      };
    }).toList();
  }

 
  void fromMap(List<Map<String, dynamic>> mapList) {
    _items.clear();
    for (var itemMap in mapList) {
      GroceryItem item = GroceryItem(
        id: itemMap['id'],
        name: itemMap['name'],
        price: (itemMap['price'] ?? 0).toDouble(),
        imagePath: itemMap['imagePath'],
        description: itemMap['description'] ?? '',
      );
      int quantity = itemMap['quantity'] ?? 1;
      _items[item] = quantity;
    }
    notifyListeners();
  }
}
