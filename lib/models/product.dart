class Product {
  final String name;
  final String description;
  final double price;
  final double rating;
  final List<String> tags;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.tags,
  });
}

const List<Product> products = [
  Product(
    name: 'Espresso',
    description: 'Strong and rich classic coffee shot.',
    price: 2.5,
    rating: 4.8,
    tags: ['Hot', 'Strong'],
  ),
  Product(
    name: 'Cappuccino',
    description: 'Espresso with creamed milk and thick foam',
    price: 3.5,
    rating: 4.8,
    tags: ['Hot', 'Milk'],
  ),
  Product(
    name: 'Latte',
    description: 'Smooth coffee with a lot of steamed milk',
    price: 3.8,
    rating: 4.6,
    tags: ['Hot', 'Milk', 'Sweet'],
  ),
  Product(
    name: 'Iced Americano',
    description: 'Espresso with cold water and ice.',
    price: 3.0,
    rating: 4.4,
    tags: ['Cold', 'Strong'],
  ),
  Product(
    name: 'Caramel Frappe',
    description: 'Blended iced coffee with caramel syrup.',
    price: 4.5,
    rating: 4.9,
    tags: ['Cold', 'Sweet'],
  ),
  Product(
    name: 'Mocha',
    description: 'Coffee mixed with chocolate and milk.',
    price: 4.0,
    rating: 4.5,
    tags: ['Hot', 'Chocolate'],
  ),
];