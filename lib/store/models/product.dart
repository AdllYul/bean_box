/// A product from the Fake Store REST API (https://fakestoreapi.com/products).
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  /// Builds a [Product] from one JSON object of the API response.
  ///
  /// Null safety: every field has a fallback (`?? default`), so a missing
  /// key never crashes the app.
  /// Numeric safety: JSON numbers can arrive as int (`695`) or double
  /// (`109.95`). Casting to `num` first and then calling `.toDouble()`
  /// accepts both. A direct `as double` would throw on `695`.
  factory Product.fromJson(Map<String, dynamic> json) {
    // "rating" is a nested object: {"rate": 3.9, "count": 120}
    final Map<String, dynamic> rating =
        json['rating'] is Map<String, dynamic>
            ? json['rating'] as Map<String, dynamic>
            : const {};

    return Product(
      id: (json['id'] as num? ?? 0).toInt(),
      title: (json['title'] as String? ?? 'Untitled product').trim(),
      price: (json['price'] as num? ?? 0).toDouble(),
      description: json['description'] as String? ?? 'No description.',
      category: json['category'] as String? ?? 'other',
      imageUrl: json['image'] as String? ?? '',
      rating: (rating['rate'] as num? ?? 0).toDouble(),
      reviewCount: (rating['count'] as num? ?? 0).toInt(),
    );
  }

  /// Photos for the detail carousel.
  /// The API returns only ONE image per product, so it is shown on
  /// 3 pages to demonstrate the swipeable gallery.
  List<String> get gallery => List.filled(3, imageUrl);

  /// Deep link that opens this product inside the app.
  String get deepLink => 'narxoz://store/product/$id';
}
