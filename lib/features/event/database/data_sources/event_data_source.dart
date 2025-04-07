import 'package:visivallet/core/database/app_database.dart';
import 'package:visivallet/features/contacts/database/tables/contact_table.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/event/database/tables/event_table.dart';
import 'package:visivallet/features/event/models/event/event.dart';

class EventDataSource {
  final AppDatabase _db;

  EventDataSource(this._db);

  Future<List<Event>> getAllEvents() async {
    final maps = await _db.query(EventTable.tableName);
    return maps.map(EventTable.fromMap).toList();
  }

  Future<Event?> getEventById(int id) async {
    final maps = await _db.query(
      EventTable.tableName,
      where: '${EventTable.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return EventTable.fromMap(maps.first);
  }

  Future<int> createEvent(Event event) async {
    return await _db.insert(
      EventTable.tableName,
      EventTable.toMap(event),
    );
  }

  Future<int> updateEvent(Event event) async {
    if (event.id == null) {
      throw Exception("Cannot update an event without an ID");
    }

    return await _db.update(
      EventTable.tableName,
      EventTable.toMap(event),
      where: '${EventTable.columnId} = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    return await _db.delete(
      EventTable.tableName,
      where: '${EventTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
