import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bean_box/providers/settings_provider.dart';
import 'package:bean_box/screens/profile_screen.dart';
import 'package:bean_box/vault/models/note_item.dart';
import 'package:bean_box/vault/services/vault_storage.dart';

Future<VaultStorage> storageWith(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  return VaultStorage(await SharedPreferences.getInstance());
}

Widget profileApp(VaultStorage storage) => MultiProvider(
      providers: [
        Provider<VaultStorage>.value(value: storage),
        ChangeNotifierProvider(create: (_) => SettingsProvider(storage)),
      ],
      child: const MaterialApp(home: ProfileScreen()),
    );

void main() {
  group('NoteItem JSON', () {
    test('toJson -> fromJson round trip', () {
      const note = NoteItem(
          id: '1', title: 'Buy beans', dateText: '19.11.2026 09:00', isCompleted: true);
      final copy = NoteItem.fromJson(note.toJson());
      expect(copy.id, '1');
      expect(copy.title, 'Buy beans');
      expect(copy.dateText, '19.11.2026 09:00');
      expect(copy.isCompleted, isTrue);
    });

    test('fromJson falls back on missing fields', () {
      final note = NoteItem.fromJson({});
      expect(note.title, 'Untitled note');
      expect(note.isCompleted, isFalse);
    });
  });

  group('VaultStorage', () {
    test('defaults when disk is empty', () async {
      final storage = await storageWith({});
      expect(storage.loadDarkMode(), isFalse);
      expect(storage.loadUserName(), 'Guest User');
      expect(storage.loadNotes(), isEmpty);
    });

    test('values survive a new instance (like a cold restart)', () async {
      final storage = await storageWith({});
      await storage.saveDarkMode(true);
      await storage.saveUserName('Aidana');
      await storage.saveNotes(const [
        NoteItem(id: 'a', title: 'First', dateText: 'd'),
        NoteItem(id: 'b', title: 'Second', dateText: 'd', isCompleted: true),
      ]);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('app_theme_dark_mode'), isTrue);
      expect(prefs.getString('user_display_name'), 'Aidana');
      expect(jsonDecode(prefs.getString(VaultStorage.notesKey)!), hasLength(2));

      final restarted = VaultStorage(prefs);
      expect(restarted.loadDarkMode(), isTrue);
      expect(restarted.loadUserName(), 'Aidana');
      expect(restarted.loadNotes().map((n) => n.title), ['First', 'Second']);
      expect(restarted.loadNotes()[1].isCompleted, isTrue);
    });

    test('corrupted JSON does not crash', () async {
      final storage = await storageWith({VaultStorage.notesKey: '{oops'});
      expect(storage.loadNotes(), isEmpty);
    });
  });

  testWidgets('profile restores, adds, toggles and deletes notes on disk',
      (tester) async {
    final storage = await storageWith({
      'user_display_name': 'Aidana',
      'app_theme_dark_mode': true,
    });
    await tester.pumpWidget(profileApp(storage));

    // Restored on launch
    expect(find.text('Aidana'), findsWidgets);
    final sw = tester.widget<SwitchListTile>(
        find.byKey(const ValueKey('dark-mode-switch')));
    expect(sw.value, isTrue);

    // Add 2 notes: newest goes first
    await tester.enterText(find.byKey(const ValueKey('note-field')), 'First');
    await tester.tap(find.byKey(const ValueKey('note-add')));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('note-field')), 'Second');
    await tester.tap(find.byKey(const ValueKey('note-add')));
    await tester.pump();
    expect(storage.loadNotes().map((n) => n.title), ['Second', 'First']);

    // Toggle
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(storage.loadNotes().first.isCompleted, isTrue);

    // Delete
    await tester.tap(find.byTooltip('Delete').first);
    await tester.pump();
    expect(storage.loadNotes().map((n) => n.title), ['First']);
  });

  testWidgets('empty name saves as Guest User', (tester) async {
    final storage = await storageWith({});
    await tester.pumpWidget(profileApp(storage));
    expect(find.text('Guest User'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('name-field')), 'Dias');
    await tester.tap(find.byKey(const ValueKey('name-save')));
    await tester.pump();
    expect(find.text('Dias'), findsWidgets);
    expect(storage.loadUserName(), 'Dias');
  });
}
