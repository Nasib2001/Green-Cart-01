import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/favorites_provider.dart';

class FavoriteToggleIcon extends StatelessWidget {
  final GroceryItem item;

  const FavoriteToggleIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(item);

    return InkWell(
      onTap: () {
        favoritesProvider.toggleFavorite(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFavorite
                ? 'Product removed from favorites'
                : 'Product added to favorites'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.blueGrey,
        size: 30,
      ),
    );
  }
}
