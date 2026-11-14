import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';

/// Opens a bottom sheet with the product's deep link and a copy button.
Future<void> showShareLinkSheet(BuildContext context, Product product) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => ShareLinkSheet(product: product),
  );
}

class ShareLinkSheet extends StatelessWidget {
  final Product product;

  const ShareLinkSheet({super.key, required this.product});

  Future<void> _copyLink(BuildContext context) async {
    // Grab these before the sheet closes and its context is gone
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await Clipboard.setData(ClipboardData(text: product.deepLink));

    navigator.pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share product', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Container(
              key: const ValueKey('deep-link-box'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectableText(
                      product.deepLink,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _copyLink(context),
                icon: const Icon(Icons.copy),
                label: const Text('Copy link'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
