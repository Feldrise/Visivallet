import 'package:visivallet/features/event/database/data_sources/event_contact_data_source.dart';
import 'package:visivallet/features/event/database/data_sources/event_data_source.dart';
import 'package:visivallet/features/event/database/repositories/event_repository.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDataSource _eventDataSource;
  final EventContactDataSource _relationshipDataSource;

  EventRepositoryImpl(this._eventDataSource, this._relationshipDataSource);

  // Event operations
  @override
  Future<List<Event>> getAllEvents() {
    return _eventDataSource.getAllEvents();
  }

  @override
  Future<List<Event>> getAllEventsFiltered(String filter) {
    return _eventDataSource.getAllEventsFiltered(filter);
  }

  @override
  Future<Event?> getEventById(int id) {
    return _eventDataSource.getEventById(id);
  }

  @override
  Future<Event> createEvent(Event event) async {
    final id = await _eventDataSource.createEvent(event);
    return event.copyWith(id: id);
  }

  @override
  Future<bool> updateEvent(Event event) async {
    final result = await _eventDataSource.updateEvent(event);
    return result > 0;
  }

  @override
  Future<bool> deleteEvent(int id) async {
    final result = await _eventDataSource.deleteEvent(id);
    return result > 0;
  }

  // Contact relationship operations
  @override
  Future<List<Contact>> getContactsForEvent(int eventId) {
    return _relationshipDataSource.getContactsForEvent(eventId);
  }

  @override
  Future<List<Contact>> getContactsForEventFiltered(int eventId, String filter) {
    return _relationshipDataSource.getContactsForEventFiltered(eventId, filter);
  }

  @override
  Future<List<Event>> getEventsForContact(int contactId) {
    return _relationshipDataSource.getEventsForContact(contactId);
  }

  @override
  Future<bool> addContactToEvent(int eventId, int contactId) async {
    final result = await _relationshipDataSource.addContactToEvent(eventId, contactId);
    return result > 0;
  }

  @override
  Future<bool> removeContactFromEvent(int eventId, int contactId) async {
    final result = await _relationshipDataSource.removeContactFromEvent(eventId, contactId);
    return result > 0;
  }

  @override
  Future<bool> isContactInEvent(int eventId, int contactId) {
    return _relationshipDataSource.isContactInEvent(eventId, contactId);
  }

  @override
  Future<List<Contact>> getContactsNotInEvent(int eventId) {
    return _relationshipDataSource.getContactsNotInEvent(eventId);
  }
}
