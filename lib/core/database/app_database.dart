import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:visivallet/features/contacts/database/tables/contact_table.dart';
import 'package:visivallet/features/event/database/tables/event_contact_table.dart';
import 'package:visivallet/features/event/database/tables/event_table.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize the database
    sqfliteFfiInit();
    final db = await databaseFactoryFfi.openDatabase(
      'app_database.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(EventTable.createTable());
    await db.execute(ContactTable.createTable());
    await db.execute(EventContactTable.createTable());
  }

  // Generic database operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }
}
