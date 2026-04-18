import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/favorites_provider.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';

class FavouriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Favorites"),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 20),
                  Text("No Favorite Items", style: TextStyle(fontSize: 18)),
                  Text("Add items to your favorites to see them here."),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                GroceryItem item = favorites[index];
                return GroceryItemCardWidget(item: item);
              },
            ),
    );
  }
}
