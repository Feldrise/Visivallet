import 'package:visivallet/features/event/models/event/event.dart';

class EventTable {
  static const String tableName = 'events';

  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnDescription = 'description';

  static String createTable() {
    return '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnDescription TEXT NOT NULL
      )
    ''';
  }

  static Map<String, dynamic> toMap(Event event) {
    return {
      if (event.id != null) columnId: event.id,
      columnName: event.name,
      columnDescription: event.description,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map[columnId] as int?,
      name: map[columnName] as String,
      description: map[columnDescription] as String,
    );
  }
}
