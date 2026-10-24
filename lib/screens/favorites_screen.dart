import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Product> favorites;
  final void Function(Product) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];
          return ProductCard(
            product: product,
            isFavorite: true,
            onToggleFavorite: onToggleFavorite,
          );
        },
      ),
    );
  }
}