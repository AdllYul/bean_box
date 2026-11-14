import 'package:flutter/material.dart';

import '../../screens/cart_screens.dart';
import '../../widgets/cart_badge_button.dart';
import '../models/product.dart';
import '../services/product_api.dart';
import '../widgets/product_tile.dart';
import 'product_detail_screen.dart';

/// The 3 UI states of the feed.
enum LoadStatus { loading, success, error }

class StoreScreen extends StatefulWidget {
  /// Can be replaced in tests with a fake API.
  final ProductApi? api;

  const StoreScreen({super.key, this.api});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late final ProductApi _api = widget.api ?? ProductApi();

  LoadStatus _status = LoadStatus.loading;
  List<Product> _products = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProducts(); // status is already "loading"
  }

  /// [showSpinner]: true for "Retry Connection" (full-screen spinner),
  /// false for pull-to-refresh (the list stays visible).
  Future<void> _loadProducts({bool showSpinner = false}) async {
    if (showSpinner) {
      setState(() => _status = LoadStatus.loading);
    }

    try {
      final products = await _api.fetchProducts();
      if (!mounted) return; // the screen was closed while waiting
      setState(() {
        _products = products;
        _status = LoadStatus.success;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      if (_status == LoadStatus.success) {
        // Refresh failed but we already have data: keep the list,
        // just tell the user.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } else {
        setState(() {
          _errorMessage = e.message;
          _status = LoadStatus.error;
        });
      }
    }
  }

  void _openDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Store'),
        actions: [
          CartBadgeButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
          ),
        ],
      ),
      body: switch (_status) {
        LoadStatus.loading => const _LoadingView(),
        LoadStatus.error => _ErrorView(
            message: _errorMessage,
            onRetry: () => _loadProducts(showSpinner: true),
          ),
        LoadStatus.success => RefreshIndicator(
            onRefresh: _loadProducts,
            child: _products.isEmpty
                ? ListView(
                    // must be scrollable, otherwise pull-to-refresh won't work
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text('No products yet')),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _products.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 104),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ProductTile(
                        product: product,
                        onTap: () => _openDetail(product),
                      );
                    },
                  ),
          ),
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading products...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Connection problem',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
