import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Global cart state shared by every screen via Provider.
/// Each product is either in the cart or not (toggle semantics).
class CartProvider extends ChangeNotifier {
  // product id -> product (keeps insertion order, no duplicates)
  final Map<int, Product> _items = {};

  List<Product> get items => List.unmodifiable(_items.values);

  int get count => _items.length;

  bool get isEmpty => _items.isEmpty;

  double get totalPrice =>
      _items.values.fold(0.0, (sum, product) => sum + product.price);

  bool isInCart(Product product) => _items.containsKey(product.id);

  void add(Product product) {
    if (_items.containsKey(product.id)) return;
    _items[product.id] = product;
    notifyListeners();
  }

  void remove(Product product) {
    if (_items.remove(product.id) != null) {
      notifyListeners();
    }
  }

  void toggle(Product product) {
    if (isInCart(product)) {
      remove(product);
    } else {
      add(product);
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
