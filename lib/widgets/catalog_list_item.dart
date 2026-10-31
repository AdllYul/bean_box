import 'package:flutter/material.dart';
import '../models/product.dart';

class CatalogListItem extends StatelessWidget {
  final Product product;

  const CatalogListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Solid color, so the red delete background is hidden until you swipe
      tileColor: Theme.of(context).colorScheme.surface,
      leading: const CircleAvatar(child: Icon(Icons.coffee)),
      title: Text(product.name),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.brown.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.tags.first,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 2),
          Text('${product.rating}'),
        ],
      ),
      trailing: Text(
        '\$${product.price}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}