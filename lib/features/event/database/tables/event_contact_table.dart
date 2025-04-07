import 'package:visivallet/features/contacts/database/tables/contact_table.dart';
import 'package:visivallet/features/event/database/tables/event_table.dart';

class EventContactTable {
  static const String tableName = 'event_contacts';

  static const String columnId = 'id';
  static const String columnEventId = 'event_id';
  static const String columnContactId = 'contact_id';

  static String createTable() {
    return '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnEventId INTEGER NOT NULL,
        $columnContactId INTEGER NOT NULL,
        FOREIGN KEY ($columnEventId) REFERENCES ${EventTable.tableName} (${EventTable.columnId}) ON DELETE CASCADE,
        FOREIGN KEY ($columnContactId) REFERENCES ${ContactTable.tableName} (${ContactTable.columnId}) ON DELETE CASCADE,
        UNIQUE($columnEventId, $columnContactId)
      )
    ''';
  }

  static Map<String, dynamic> toMap(int eventId, int contactId) {
    return {
      columnEventId: eventId,
      columnContactId: contactId,
    };
  }
}
