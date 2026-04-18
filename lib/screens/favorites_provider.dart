import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart';

class FavoritesProvider with ChangeNotifier {
  final List<GroceryItem> _favorites = [];

  List<GroceryItem> get favorites => _favorites;

  void toggleFavorite(GroceryItem item) {
    if (_favorites.contains(item)) {
      _favorites.remove(item);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }

  bool isFavorite(GroceryItem item) {
    return _favorites.contains(item);
  }
}
