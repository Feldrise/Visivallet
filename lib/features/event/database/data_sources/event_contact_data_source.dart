import 'package:visivallet/core/database/app_database.dart';
import 'package:visivallet/features/contacts/database/tables/contact_table.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/event/database/tables/event_contact_table.dart';
import 'package:visivallet/features/event/database/tables/event_table.dart';
import 'package:visivallet/features/event/models/event/event.dart';

class EventContactDataSource {
  final AppDatabase _db;

  EventContactDataSource(this._db);

  // Add a contact to an event
  Future<int> addContactToEvent(int eventId, int contactId) async {
    return await _db.insert(
      EventContactTable.tableName,
      EventContactTable.toMap(eventId, contactId),
    );
  }

  // Remove a contact from an event
  Future<int> removeContactFromEvent(int eventId, int contactId) async {
    return await _db.delete(
      EventContactTable.tableName,
      where: '${EventContactTable.columnEventId} = ? AND ${EventContactTable.columnContactId} = ?',
      whereArgs: [eventId, contactId],
    );
  }

  // Get all contacts for a specific event
  Future<List<Contact>> getContactsForEvent(int eventId) async {
    final sql = '''
      SELECT c.*
      FROM ${ContactTable.tableName} c
      JOIN ${EventContactTable.tableName} ec ON c.${ContactTable.columnId} = ec.${EventContactTable.columnContactId}
      WHERE ec.${EventContactTable.columnEventId} = ?
    ''';

    final maps = await _db.rawQuery(sql, [eventId]);
    return maps.map(ContactTable.fromMap).toList();
  }

  // Get all contacts for a specific event with filtering
  Future<List<Contact>> getContactsForEventFiltered(int eventId, String filter) async {
    final sql = '''
      SELECT c.*
      FROM ${ContactTable.tableName} c
      JOIN ${EventContactTable.tableName} ec ON c.${ContactTable.columnId} = ec.${EventContactTable.columnContactId}
      WHERE ec.${EventContactTable.columnEventId} = ?
      AND (c.${ContactTable.columnFirstName} LIKE ? OR c.${ContactTable.columnLastName} LIKE ? OR c.${ContactTable.columnEmail} LIKE ? OR c.${ContactTable.columnPhone} LIKE ?)
    ''';

    final maps = await _db.rawQuery(sql, [eventId, '%$filter%', '%$filter%', '%$filter%', '%$filter%']);
    return maps.map(ContactTable.fromMap).toList();
  }

  // Get all events for a specific contact
  Future<List<Event>> getEventsForContact(int contactId) async {
    final sql = '''
      SELECT e.*
      FROM ${EventTable.tableName} e
      JOIN ${EventContactTable.tableName} ec ON e.${EventTable.columnId} = ec.${EventContactTable.columnEventId}
      WHERE ec.${EventContactTable.columnContactId} = ?
    ''';

    final maps = await _db.rawQuery(sql, [contactId]);
    return maps.map(EventTable.fromMap).toList();
  }

  // Check if a contact is in an event
  Future<bool> isContactInEvent(int eventId, int contactId) async {
    final result = await _db.query(
      EventContactTable.tableName,
      where: '${EventContactTable.columnEventId} = ? AND ${EventContactTable.columnContactId} = ?',
      whereArgs: [eventId, contactId],
    );

    return result.isNotEmpty;
  }

  // Get all contacts not in a specific event (for adding new contacts to an event)
  Future<List<Contact>> getContactsNotInEvent(int eventId) async {
    final sql = '''
      SELECT * FROM ${ContactTable.tableName}
      WHERE ${ContactTable.columnId} NOT IN (
        SELECT ${EventContactTable.columnContactId}
        FROM ${EventContactTable.tableName}
        WHERE ${EventContactTable.columnEventId} = ?
      )
    ''';

    final maps = await _db.rawQuery(sql, [eventId]);
    return maps.map(ContactTable.fromMap).toList();
  }
}
