import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final void Function(Product) onToggleFavorite;

  const DetailScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      product.image,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 220,
                          width: double.infinity,
                          color: Colors.brown.shade200,
                          child: const Icon(Icons.coffee, size: 100),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          widget.onToggleFavorite(product);
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        color: Colors.black54,
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${product.rating}'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: product.tags
                            .map((tag) => Chip(label: Text(tag)))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back to menu'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart')),
                  );
                },
                child: const Text('Add to cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}