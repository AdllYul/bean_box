import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';
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
        title: const Text('BeanBox'),
        actions: [
          ValueListenableBuilder<Map<Product, int>>(
            valueListenable: cart,
            builder: (context, items, child) {
              final count = items.values.fold(0, (sum, qty) => sum + qty);
              return IconButton(
                icon: Badge(
                  label: Text('$count'),
                  isLabelVisible: count > 0,
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
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