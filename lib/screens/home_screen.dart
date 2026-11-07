import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/product_card.dart';
import 'cart_screens.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> favorites;
  final void Function(Product) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BeanBox Catalog'),
        actions: [
          CartBadgeButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            isFavorite: favorites.contains(product),
            onToggleFavorite: onToggleFavorite,
          );
        },
      ),
    );
  }
}