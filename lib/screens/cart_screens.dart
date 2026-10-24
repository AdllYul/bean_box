import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ValueListenableBuilder<Map<Product, int>>(
        valueListenable: cart,
        builder: (context, items, child) {
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          double total = 0;
          items.forEach((product, qty) {
            total += product.price * qty;
          });

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: items.entries.map((entry) {
                    final product = entry.key;
                    final qty = entry.value;
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          product.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 56,
                              height: 56,
                              color: Colors.brown.shade100,
                              child: const Icon(Icons.coffee),
                            );
                          },
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price} x $qty'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => removeFromCart(product),
                          ),
                          Text('$qty'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => addToCart(product),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
