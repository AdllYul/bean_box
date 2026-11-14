import 'package:flutter/material.dart';
import '../models/product.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../store/screens/store_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;
  // The Store tab is built (and starts its network request)
  // only when the user opens it for the first time.
  bool storeOpened = false;
  final List<Product> favorites = [];

  void toggleFavorite(Product product) {
    setState(() {
      if (favorites.contains(product)) {
        favorites.remove(product);
      } else {
        favorites.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(favorites: favorites, onToggleFavorite: toggleFavorite),
      FavoritesScreen(favorites: favorites, onToggleFavorite: toggleFavorite),
      const ProfileScreen(),
      storeOpened ? const StoreScreen() : const SizedBox.shrink(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        // 4+ items default to 'shifting' (white icons) — keep them fixed
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            if (index == 3) storeOpened = true;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Store',
          ),
        ],
      ),
    );
  }
}