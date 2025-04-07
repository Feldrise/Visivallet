import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';

abstract class EventRepository {
  // Event operations
  Future<List<Event>> getAllEvents();
  Future<Event?> getEventById(int id);
  Future<Event> createEvent(Event event);
  Future<bool> updateEvent(Event event);
  Future<bool> deleteEvent(int id);

  // Contact relationship operations
  Future<List<Contact>> getContactsForEvent(int eventId);
  Future<List<Event>> getEventsForContact(int contactId);
  Future<bool> addContactToEvent(int eventId, int contactId);
  Future<bool> removeContactFromEvent(int eventId, int contactId);
  Future<bool> isContactInEvent(int eventId, int contactId);
  Future<List<Contact>> getContactsNotInEvent(int eventId);
}
