import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_item.dart';

/// All reads and writes to local disk (SharedPreferences) live here.
///
/// SharedPreferences stores simple key-value pairs:
/// Android -> XML file, iOS -> NSUserDefaults, Web -> localStorage.
/// It is NOT encrypted, so never store passwords or tokens here
/// (use Keychain / Android KeyStore via flutter_secure_storage instead).
class VaultStorage {
  static const String darkModeKey = 'app_theme_dark_mode';
  static const String userNameKey = 'user_display_name';
  static const String notesKey = 'vault_notes_json';

  static const String defaultUserName = 'Guest User';

  /// Instance is created once in main(), before runApp().
  /// After getInstance() all values are cached in memory,
  /// so every get... below is synchronous and instant.
  final SharedPreferences _prefs;

  VaultStorage(this._prefs);

  // ---- bool ----
  bool loadDarkMode() => _prefs.getBool(darkModeKey) ?? false;

  Future<void> saveDarkMode(bool value) => _prefs.setBool(darkModeKey, value);

  // ---- String ----
  String loadUserName() => _prefs.getString(userNameKey) ?? defaultUserName;

  Future<void> saveUserName(String name) =>
      _prefs.setString(userNameKey, name);

  // ---- List<NoteItem> as one JSON string ----
  List<NoteItem> loadNotes() {
    final String? jsonString = _prefs.getString(notesKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) => NoteItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupted data on disk must not crash the app
      return [];
    }
  }

  Future<void> saveNotes(List<NoteItem> notes) {
    // List<NoteItem> -> List<Map> -> String
    final String jsonString =
        jsonEncode(notes.map((note) => note.toJson()).toList());
    return _prefs.setString(notesKey, jsonString);
  }
}
