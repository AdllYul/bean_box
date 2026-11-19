import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../vault/models/note_item.dart';
import '../vault/services/vault_storage.dart';
import 'catalog_screen.dart';

/// LW11: Offline-First Notes & Settings Vault.
/// Everything on this screen is saved to disk and restored on launch.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final VaultStorage _storage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _userName = VaultStorage.defaultUserName;
  List<NoteItem> _notes = [];

  @override
  void initState() {
    super.initState();
    _storage = context.read<VaultStorage>();
    // Synchronous: SharedPreferences was already loaded in main()
    _userName = _storage.loadUserName();
    _notes = _storage.loadNotes();
    if (_userName != VaultStorage.defaultUserName) {
      _nameController.text = _userName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ---------- username ----------
  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    final newName = name.isEmpty ? VaultStorage.defaultUserName : name;

    setState(() => _userName = newName);
    await _storage.saveUserName(newName);

    if (!mounted) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name saved')),
    );
  }

  // ---------- notes ----------
  /// Every change: update the list -> redraw -> write the whole list to disk.
  void _updateNotes(List<NoteItem> newNotes) {
    setState(() => _notes = newNotes);
    _storage.saveNotes(newNotes);
  }

  void _addNote() {
    final title = _noteController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final note = NoteItem(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      dateText: _formatDate(now),
    );

    _updateNotes([note, ..._notes]); // prepend: newest first
    _noteController.clear();
  }

  void _toggleNote(NoteItem note) {
    _updateNotes([
      for (final n in _notes)
        n.id == note.id ? n.copyWith(isCompleted: !n.isCompleted) : n,
    ]);
  }

  void _deleteNote(NoteItem note) {
    _updateNotes(_notes.where((n) => n.id != note.id).toList());
  }

  static String _formatDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.select<SettingsProvider, bool>(
      (settings) => settings.isDarkMode,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Notes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Header ----
          Row(
            children: [
              const CircleAvatar(radius: 32, child: Icon(Icons.person, size: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello,', style: theme.textTheme.bodyMedium),
                    Text(
                      _userName,
                      key: const ValueKey('header-name'),
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ---- Username ----
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('name-field'),
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _saveName(),
                  decoration: const InputDecoration(
                    labelText: 'Your name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                key: const ValueKey('name-save'),
                onPressed: _saveName,
                child: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ---- Dark mode ----
          SwitchListTile(
            key: const ValueKey('dark-mode-switch'),
            contentPadding: EdgeInsets.zero,
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark mode'),
            value: isDarkMode,
            onChanged: (value) =>
                context.read<SettingsProvider>().setDarkMode(value),
          ),
          const Divider(height: 32),

          // ---- Notes ----
          Text('My notes (${_notes.length})', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('note-field'),
                  controller: _noteController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addNote(),
                  decoration: const InputDecoration(
                    hintText: 'New note...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                key: const ValueKey('note-add'),
                tooltip: 'Add note',
                onPressed: _addNote,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_notes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('No notes yet')),
            ),
          for (final note in _notes)
            CheckboxListTile(
              key: ValueKey('note-${note.id}'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: note.isCompleted,
              onChanged: (_) => _toggleNote(note),
              title: Text(
                note.title,
                style: TextStyle(
                  decoration:
                      note.isCompleted ? TextDecoration.lineThrough : null,
                  color: note.isCompleted ? theme.disabledColor : null,
                ),
              ),
              subtitle: Text(note.dateText),
              secondary: IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                color: theme.colorScheme.error,
                onPressed: () => _deleteNote(note),
              ),
            ),
          const Divider(height: 32),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.grid_view),
            title: const Text('Smart Catalog (LW8)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CatalogScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
