import 'package:visivallet/features/user/models/user_profile/user_profile.dart';

class UserProfileTable {
  static const String tableName = 'user_profile';

  static const String columnId = 'id';
  static const String columnFirstName = 'first_name';
  static const String columnLastName = 'last_name';
  static const String columnUserId = 'user_id';

  static String createTable() {
    return '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserId INTEGER NOT NULL,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        FOREIGN KEY ($columnUserId) REFERENCES users(id)
      )
    ''';
  }

  static Map<String, dynamic> toMap(UserProfile userProfile) {
    return {
      if (userProfile.id != null) columnId: userProfile.id,
      columnUserId: userProfile.userId,
      columnFirstName: userProfile.firstName,
      columnLastName: userProfile.lastName,
    };
  }

  static UserProfile fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map[columnId] as int?,
      userId: map[columnUserId] as int,
      firstName: map[columnFirstName] as String,
      lastName: map[columnLastName] as String,
    );
  }
}
