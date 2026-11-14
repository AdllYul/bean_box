import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

import 'package:bean_box/providers/cart_provider.dart';
import 'package:bean_box/store/models/product.dart';
import 'package:bean_box/store/screens/store_screen.dart';
import 'package:bean_box/store/services/product_api.dart';

const sampleJson = [
  {
    'id': 5,
    'title': 'Gold Bracelet',
    'price': 695, // int, not double!
    'description': 'Shiny',
    'category': 'jewelery',
    'image': 'https://example.com/a.png',
    'rating': {'rate': 3, 'count': 400}, // int rate
  },
  {
    'id': 1,
    'title': 'Backpack',
    'price': 109.95,
    'description': 'Bag',
    'category': "men's clothing",
    'image': 'https://example.com/b.png',
    'rating': {'rate': 3.9, 'count': 120},
  },
];

ProductApi apiReturning(int status, [Object body = sampleJson]) => ProductApi(
      client: MockClient(
        (request) async => http.Response(jsonEncode(body), status),
      ),
    );

void main() {
  group('Product.fromJson', () {
    test('int price and int rate become double', () {
      final p = Product.fromJson(sampleJson[0]);
      expect(p.price, 695.0);
      expect(p.price, isA<double>());
      expect(p.rating, 3.0);
      expect(p.reviewCount, 400);
      expect(p.imageUrl, 'https://example.com/a.png');
      expect(p.deepLink, 'narxoz://store/product/5');
    });

    test('missing fields fall back to defaults', () {
      final p = Product.fromJson({'id': 7});
      expect(p.title, 'Untitled product');
      expect(p.price, 0.0);
      expect(p.category, 'other');
      expect(p.imageUrl, '');
      expect(p.rating, 0.0);
      expect(p.reviewCount, 0);
      expect(p.gallery.length, 3);
    });
  });

  group('ProductApi', () {
    test('200 returns parsed products', () async {
      final products = await apiReturning(200).fetchProducts();
      expect(products.length, 2);
      expect(products.first.title, 'Gold Bracelet');
    });

    test('404 throws ApiException', () {
      expect(
        apiReturning(404).fetchProducts(),
        throwsA(isA<ApiException>()
            .having((e) => e.message, 'message', contains('404'))),
      );
    });

    test('500 throws ApiException', () {
      expect(
        apiReturning(500).fetchProducts(),
        throwsA(isA<ApiException>()
            .having((e) => e.message, 'message', contains('500'))),
      );
    });

    test('no internet throws offline ApiException', () {
      final api = ProductApi(
        client: MockClient((request) async {
          throw http.ClientException('Failed host lookup');
        }),
      );
      expect(
        api.fetchProducts(),
        throwsA(isA<ApiException>()
            .having((e) => e.message, 'message', contains('No internet'))),
      );
    });

    test('slow server hits the timeout', () {
      final api = ProductApi(
        timeout: const Duration(milliseconds: 50),
        client: MockClient((request) async {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          return http.Response('[]', 200);
        }),
      );
      expect(
        api.fetchProducts(),
        throwsA(isA<ApiException>()
            .having((e) => e.message, 'message', contains('did not respond'))),
      );
    });
  });

  testWidgets('error screen -> Retry Connection -> product list',
      (tester) async {
    var calls = 0;
    final api = ProductApi(
      client: MockClient((request) async {
        calls++;
        if (calls == 1) throw http.ClientException('offline');
        return http.Response(jsonEncode(sampleJson), 200);
      }),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: MaterialApp(home: StoreScreen(api: api)),
      ),
    );

    // 1. Loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 2. Error
    await tester.pump();
    await tester.pump();
    expect(find.text('Retry Connection'), findsOneWidget);

    // 3. Retry -> Success
    await tester.tap(find.text('Retry Connection'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Gold Bracelet'), findsOneWidget);
    expect(find.text('\$695.00'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(calls, 2);
  });
}
