import 'package:visivallet/core/database/app_database.dart';
import 'package:visivallet/features/contacts/database/tables/contact_table.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';

class ContactDataSource {
  final AppDatabase _db;

  ContactDataSource(this._db);

  Future<List<Contact>> getAllContacts() async {
    final maps = await _db.query(ContactTable.tableName);
    return maps.map(ContactTable.fromMap).toList();
  }

  Future<Contact?> getContactById(int id) async {
    final maps = await _db.query(
      ContactTable.tableName,
      where: '${ContactTable.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ContactTable.fromMap(maps.first);
  }

  Future<int> createContact(Contact contact) async {
    return await _db.insert(
      ContactTable.tableName,
      ContactTable.toMap(contact),
    );
  }

  Future<int> updateContact(Contact contact) async {
    if (contact.id == null) {
      throw Exception("Cannot update a contact without an ID");
    }

    return await _db.update(
      ContactTable.tableName,
      ContactTable.toMap(contact),
      where: '${ContactTable.columnId} = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    return await _db.delete(
      ContactTable.tableName,
      where: '${ContactTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
