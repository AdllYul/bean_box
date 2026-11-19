import 'package:flutter/foundation.dart';

import '../vault/services/vault_storage.dart';

/// App-wide theme setting. MaterialApp listens to it.
class SettingsProvider extends ChangeNotifier {
  final VaultStorage _storage;
  bool _isDarkMode;

  /// The saved value is read right here, before the first frame,
  /// so the app starts in the correct theme (no white flash).
  SettingsProvider(this._storage) : _isDarkMode = _storage.loadDarkMode();

  bool get isDarkMode => _isDarkMode;

  Future<void> setDarkMode(bool value) async {
    if (value == _isDarkMode) return;
    _isDarkMode = value;
    notifyListeners(); // UI switches immediately
    await _storage.saveDarkMode(value); // then persisted to disk
  }
}
