/// One note in the Notes & Settings Vault.
class NoteItem {
  final String id;
  final String title;
  final String dateText;
  final bool isCompleted;

  const NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    this.isCompleted = false,
  });

  /// Object -> Map (then jsonEncode turns the Map into a String).
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateText': dateText,
        'isCompleted': isCompleted,
      };

  /// Map (from jsonDecode) -> Object, with null-safe fallbacks.
  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Untitled note',
      dateText: json['dateText'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Same note with some fields changed (objects are immutable).
  NoteItem copyWith({bool? isCompleted}) => NoteItem(
        id: id,
        title: title,
        dateText: dateText,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}
