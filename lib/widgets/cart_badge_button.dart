import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

/// AppBar cart icon with a live item counter.
/// Only this small widget rebuilds when the cart changes.
class CartBadgeButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CartBadgeButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return IconButton(
          tooltip: 'Cart',
          onPressed: onPressed,
          icon: Badge(
            label: Text('${cart.count}'),
            isLabelVisible: cart.count > 0,
            child: child,
          ),
        );
      },
      child: const Icon(Icons.shopping_cart),
    );
  }
}
