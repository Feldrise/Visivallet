import 'package:visivallet/features/contacts/models/contact/contact.dart';

class ContactTable {
  static const String tableName = 'contacts';

  static const String columnId = 'id';
  static const String columnFirstName = 'first_name';
  static const String columnLastName = 'last_name';
  static const String columnEmail = 'email';
  static const String columnPhone = 'phone';

  static String createTable() {
    return '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnPhone TEXT NOT NULL
      )
    ''';
  }

  static Map<String, dynamic> toMap(Contact contact) {
    return {
      if (contact.id != null) columnId: contact.id,
      columnFirstName: contact.firstName,
      columnLastName: contact.lastName,
      columnEmail: contact.email,
      columnPhone: contact.phone,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map[columnId] as int?,
      firstName: map[columnFirstName] as String,
      lastName: map[columnLastName] as String,
      email: map[columnEmail] as String,
      phone: map[columnPhone] as String,
    );
  }
}
