# BeanBox

Coffee shop mobile app built with Flutter.

## Problem and user
Helps coffee lovers quickly browse drinks, see details and save favorites.

## Features (Milestone 1)
- Home screen with a list of products (Card, Row, Column)
- Detail screen with Stack banner, tags and bottom bar
- Favorite button (StatefulWidget + setState)

## Project structure
- lib/models - data classes
- lib/screens - app screens
- lib/widgets - reusable widgets

## Run
flutter pub get
flutter run -d chrome

## Lab 7: Navigation
- BottomNavigationBar with 3 tabs: Feed, Favorites, Profile
- Navigator.push with the Product object passed to DetailScreen
- Navigator.pop (AppBar arrow and in-body "Back to menu" button)
- Shared favorites list managed in RootScreen with setState
## Lab 9: Provider – Multi-Screen Global Cart

- `CartProvider` (`lib/providers/cart_provider.dart`) extends `ChangeNotifier`: `add`, `remove`, `toggle`, `clear`, `count`, `totalPrice`
- `ChangeNotifierProvider` wraps `MaterialApp` in `main.dart`, so every route shares one cart
- Catalog (Feed tab): 6 coffees, each with an "Add to Cart" / "In Cart" toggle; live badge on the AppBar cart icon (`CartBadgeButton`)
- Cart screen: list of selected items, remove button per item (with UNDO), total price, "Clear All" with confirmation
- Removing items in Cart instantly updates the toggles and the badge in Catalog — no `setState` or callbacks needed
- `flutter test` covers the provider logic and the Cart → Catalog sync

## Lab 10: Cloud Product Explorer & Detail Carousel

New **Store** tab that loads products from `https://fakestoreapi.com/products`.

- `lib/store/models/product.dart` — `Product` with `fromJson`: null-safe fallbacks and `(json['price'] as num? ?? 0).toDouble()` so int prices like `695` don't crash
- `lib/store/services/product_api.dart` — `http.get` with a 10-second timeout and `try-catch`; handles `200`, `404`, `5xx`, offline (`ClientException`) and timeout with user-friendly `ApiException` messages
- `lib/store/screens/store_screen.dart` — 3 UI states: loading spinner, `ListView.separated` feed with `RefreshIndicator`, error screen with **Retry Connection**
- `lib/store/screens/product_detail_screen.dart` — `Hero(tag: 'product_image_${id}')`, `PageView.builder` carousel with `1 / 3` counter and animated dots, category badge, description, sticky **Add to Cart** (uses the global Provider cart)
- `lib/store/widgets/share_link_sheet.dart` — bottom sheet with the deep link `narxoz://store/product/{id}` and a copy button
- `test/store_test.dart` — JSON parsing, status codes, offline, timeout, and error → retry → success

Offline test in Chrome: DevTools → Network → **Offline**, then pull to refresh / Retry Connection. On a phone or emulator: airplane mode.
