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

## Lab 11: Local Data Storage & Offline Persistence

The **Profile** tab is now an offline-first Notes & Settings Vault (`shared_preferences: ^2.2.2`).

- `main.dart` — `WidgetsFlutterBinding.ensureInitialized()` + `await SharedPreferences.getInstance()` **before** `runApp()`, so the saved theme is applied on the first frame (no white flash)
- `lib/vault/services/vault_storage.dart` — all disk access: `getBool/setBool('app_theme_dark_mode')` with `?? false`, `getString/setString('user_display_name')` with `?? 'Guest User'`, notes as one JSON string
- `lib/providers/settings_provider.dart` — dark mode for the whole app (`themeMode`)
- `lib/vault/models/note_item.dart` — `NoteItem` (`id`, `title`, `dateText`, `isCompleted`) with `toJson()` / `fromJson()`
- `lib/screens/profile_screen.dart` — name field + Save, dark mode switch, notes: add (prepend), toggle, delete; every change re-encodes the list with `jsonEncode` and saves it
- `test/vault_test.dart` — JSON round trip, defaults, values surviving a new instance, and the add/toggle/delete flow

Cold restart test: add 2 notes, turn on dark mode, fully close the app (swipe it away / stop the run), reopen — everything is restored.
Note: SharedPreferences is plain, unencrypted storage. Secrets (passwords, tokens) belong in Keychain (iOS) / KeyStore (Android), e.g. via `flutter_secure_storage`.
