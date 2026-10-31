import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/catalog_grid_card.dart';
import '../widgets/catalog_list_item.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Product> catalog = List.of(products);
  bool isGrid = false;
  int nextId = 100;

  // Creates a "new" product for pull-to-refresh
  Product _generateProduct() {
    final base = products[nextId % products.length];
    final product = Product(
      id: nextId,
      name: '${base.name} #$nextId',
      description: base.description,
      image: base.image,
      price: base.price,
      rating: base.rating,
      tags: base.tags,
    );
    nextId++;
    return product;
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      catalog.insert(0, _generateProduct());
    });
  }

  void _removeItem(int index) {
    final removed = catalog[index];
    setState(() {
      catalog.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.name} removed'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            if (!mounted) return;
            setState(() {
              final safeIndex =
              index > catalog.length ? catalog.length : index;
              catalog.insert(safeIndex, removed);
            });
          },
        ),
      ),
    );
  }

  void _resetCatalog() {
    setState(() {
      catalog = List.of(products);
    });
  }

  Widget _deleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: catalog.length,
      separatorBuilder: (context, index) =>
      const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final product = catalog[index];
        return Dismissible(
          key: ValueKey(product.id),
          direction: DismissDirection.endToStart,
          background: _deleteBackground(),
          onDismissed: (direction) => _removeItem(index),
          child: CatalogListItem(product: product),
        );
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: catalog.length,
      itemBuilder: (context, index) {
        final product = catalog[index];
        return Dismissible(
          key: ValueKey(product.id),
          direction: DismissDirection.endToStart,
          background: _deleteBackground(),
          onDismissed: (direction) => _removeItem(index),
          child: CatalogGridCard(product: product),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Catalog is Empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _resetCatalog,
            icon: const Icon(Icons.restore),
            label: const Text('Reset Catalog'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Catalog'),
        actions: [
          IconButton(
            tooltip: isGrid ? 'Show list' : 'Show grid',
            icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: catalog.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _refresh,
        child: isGrid ? _buildGrid() : _buildList(),
      ),
    );
  }
}