import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
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
    final int id = await _db.insert(
      ContactTable.tableName,
      ContactTable.toMap(contact),
    );

    // If there is an image, save it to the file system or database
    if (contact.imageBase64 == null) {
      return id;
    }

    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory contactsDir = Directory('${directory.path}/contacts');

    if (!await contactsDir.exists()) {
      await contactsDir.create(recursive: true);
    }

    final String filename = 'contact_$id.png';
    final File file = File('${contactsDir.path}/$filename');

    // Save the image to the file system
    await file.writeAsBytes(base64Decode(contact.imageBase64!));

    return id;
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
