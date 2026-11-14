import '../models/product.dart' as cart;
import 'models/product.dart';

/// Store ids (1..20) would clash with coffee ids (1..6) in the cart,
/// so store items get an offset.
const int storeCartIdOffset = 10000;

extension StoreProductToCart on Product {
  /// Converts an API product into the item type the global cart stores.
  cart.Product toCartItem() => cart.Product(
        id: storeCartIdOffset + id,
        name: title,
        description: description,
        image: imageUrl,
        price: price,
        rating: rating,
        tags: [category],
      );
}
