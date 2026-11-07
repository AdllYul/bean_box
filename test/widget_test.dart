import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bean_box/main.dart';
import 'package:bean_box/models/product.dart';
import 'package:bean_box/providers/cart_provider.dart';

Widget buildApp() => ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    );

Finder badgeText(String text) =>
    find.descendant(of: find.byType(Badge), matching: find.text(text));

void main() {
  group('CartProvider', () {
    test('toggle adds and removes, total is summed', () {
      final cart = CartProvider();
      cart.toggle(products[0]); // Espresso 2.5
      cart.toggle(products[1]); // Cappuccino 3.5
      expect(cart.count, 2);
      expect(cart.totalPrice, 6.0);

      cart.toggle(products[0]);
      expect(cart.isInCart(products[0]), isFalse);
      expect(cart.totalPrice, 3.5);

      cart.add(products[1]); // no duplicates
      expect(cart.count, 1);

      cart.clear();
      expect(cart.isEmpty, isTrue);
    });
  });

  testWidgets('removing an item in Cart syncs back to Catalog',
      (tester) async {
    await tester.pumpWidget(buildApp());
    const toggleKey = ValueKey('cart-toggle-1'); // Espresso

    // Screen 1: add to cart -> toggle + badge update
    await tester.tap(find.byKey(toggleKey));
    await tester.pump();
    expect(
      find.descendant(of: find.byKey(toggleKey), matching: find.text('In Cart')),
      findsOneWidget,
    );
    expect(badgeText('1'), findsOneWidget);

    // Open Screen 2
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();
    expect(find.text('Cart (1)'), findsOneWidget);
    expect(find.text('\$2.50'), findsWidgets);

    // Remove on Screen 2
    await tester.tap(find.byKey(const ValueKey('cart-remove-1')));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);

    // Back to Screen 1: toggle and badge are already in sync
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      find.descendant(
          of: find.byKey(toggleKey), matching: find.text('Add to Cart')),
      findsOneWidget,
    );
    expect(badgeText('1'), findsNothing);
  });
}
