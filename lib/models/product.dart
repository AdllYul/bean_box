class Product {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  final double rating;
  final List<String> tags;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.tags,
  });
}

const List<Product> products = [
  Product(
    id: 1,
    name: 'Espresso',
    description: 'Strong and rich classic coffee shot.',
    image: 'assets/images/espresso.webp',
    price: 2.5,
    rating: 4.8,
    tags: ['Hot', 'Strong'],
  ),
  Product(
    id: 2,
    name: 'Cappuccino',
    description: 'Espresso with creamed milk and thick foam',
    image: 'assets/images/cappuccino.jpeg',
    price: 3.5,
    rating: 4.8,
    tags: ['Hot', 'Milk'],
  ),
  Product(
    id: 3,
    name: 'Latte',
    description: 'Smooth coffee with a lot of steamed milk',
    image: 'assets/images/latte.jpg',
    price: 3.8,
    rating: 4.6,
    tags: ['Hot', 'Milk', 'Sweet'],
  ),
  Product(
    id: 4,
    name: 'Iced Americano',
    description: 'Espresso with cold water and ice.',
    image: 'assets/images/iced_americano.webp',
    price: 3.0,
    rating: 4.4,
    tags: ['Cold', 'Strong'],
  ),
  Product(
    id: 5,
    name: 'Caramel Frappe',
    description: 'Blended iced coffee with caramel syrup.',
    image: 'assets/images/caramel_flappe.jpeg',
    price: 4.5,
    rating: 4.9,
    tags: ['Cold', 'Sweet'],
  ),
  Product(
    id: 6,
    name: 'Mocha',
    description: 'Coffee mixed with chocolate and milk.',
    image: 'assets/images/mocha.jpeg',
    price: 4.0,
    rating: 4.5,
    tags: ['Hot', 'Chocolate'],
  ),
];