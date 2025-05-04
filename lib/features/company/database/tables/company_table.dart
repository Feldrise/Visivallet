import 'package:visivallet/features/company/models/company/company.dart';

class CompanyTable {
  static const String tableName = 'companies';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnSiret = 'siret';
  static const String columnDescription = 'description';

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnSiret TEXT,
      $columnDescription TEXT
    )
  ''';

  static Map<String, Object?> toMap(Company company) {
    return {
      if (company.id != null) columnId: company.id,
      columnName: company.name,
      columnSiret: company.siret,
      columnDescription: company.description,
    };
  }

  static Company fromMap(Map<String, Object?> map) {
    return Company(
      id: map[columnId] as int?,
      name: map[columnName] as String,
      siret: map[columnSiret] as String?,
      description: map[columnDescription] as String?,
    );
  }
}
