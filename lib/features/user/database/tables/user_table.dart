import 'package:visivallet/features/user/models/user/user.dart';

class UserTable {
  static const String tableName = 'users';

  static const String columnId = 'id';
  static const String columnEmail = 'email';
  static const String columnPhone = 'phone';

  static String createTable() {
    return '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnEmail TEXT NOT NULL,
        $columnPhone TEXT NOT NULL
      )
    ''';
  }

  static Map<String, dynamic> toMap(User user) {
    return {
      if (user.id != null) columnId: user.id,
      columnEmail: user.email,
      columnPhone: user.phone,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map[columnId] as int?,
      email: map[columnEmail] as String,
      phone: map[columnPhone] as String,
    );
  }
}
