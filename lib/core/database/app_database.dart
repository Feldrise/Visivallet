import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:visivallet/features/company/database/tables/company_table.dart';
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
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
    }

    databaseFactory = databaseFactoryFfi;

    // final String path = await getDatabasesPath();
    final Directory pathDirectory = await getApplicationDocumentsDirectory();

    if (!(await pathDirectory.exists())) {
      await pathDirectory.create(recursive: true);
    }

    final String path = pathDirectory.path;
    final db = await databaseFactory.openDatabase(
      join(path, 'visivallet_database.db'),
      options: OpenDatabaseOptions(
        version: 2, // Incrementing version for migration
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(EventTable.createTable());

    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');

    // Create tables with relationships
    await db.execute(CompanyTable.createTableQuery);
    await db.execute(ContactTable.createTable());
    await db.execute(EventContactTable.createTable());
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations based on version
    if (oldVersion < 2) {
      // Enable foreign keys
      await db.execute('PRAGMA foreign_keys = ON');

      // Migration to version 2: Add company table and update contacts table
      await db.execute(CompanyTable.createTableQuery);

      // For existing tables, we need to recreate them to add foreign key constraints
      // First, backup existing contacts
      await db.execute('ALTER TABLE ${ContactTable.tableName} RENAME TO contacts_backup');

      // Create new contacts table with foreign key
      await db.execute(ContactTable.createTable());

      // Copy data from backup to new table
      await db.execute('''
        INSERT INTO ${ContactTable.tableName}
        (${ContactTable.columnId}, ${ContactTable.columnFirstName}, ${ContactTable.columnLastName}, 
        ${ContactTable.columnEmail}, ${ContactTable.columnPhone})
        SELECT id, first_name, last_name, email, phone FROM contacts_backup
      ''');

      // Drop backup table
      await db.execute('DROP TABLE contacts_backup');
    }
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
