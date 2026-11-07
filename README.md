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
