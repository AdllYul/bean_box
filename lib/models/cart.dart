import 'package:flutter/foundation.dart';
import 'product.dart';

// product -> quantity
final ValueNotifier<Map<Product, int>> cart = ValueNotifier({});

void addToCart(Product product) {
  final updated = Map<Product, int>.from(cart.value);
  updated[product] = (updated[product] ?? 0) + 1;
  cart.value = updated;
}

void removeFromCart(Product product) {
  final updated = Map<Product, int>.from(cart.value);
  final qty = updated[product] ?? 0;
  if (qty <= 1) {
    updated.remove(product);
  } else {
    updated[product] = qty - 1;
  }
  cart.value = updated;
}