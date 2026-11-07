import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

/// "Add to Cart" / "In Cart" toggle for a single product.
class AddToCartButton extends StatelessWidget {
  final Product product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // select: rebuild only when THIS product's in-cart state changes
    final inCart = context.select<CartProvider, bool>(
      (cart) => cart.isInCart(product),
    );

    void onPressed() => context.read<CartProvider>().toggle(product);

    if (inCart) {
      return FilledButton.icon(
        key: ValueKey('cart-toggle-${product.id}'),
        onPressed: onPressed,
        icon: const Icon(Icons.check),
        label: const Text('In Cart'),
      );
    }
    return OutlinedButton.icon(
      key: ValueKey('cart-toggle-${product.id}'),
      onPressed: onPressed,
      icon: const Icon(Icons.add_shopping_cart),
      label: const Text('Add to Cart'),
    );
  }
}
