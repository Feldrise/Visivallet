import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/database/app_database.dart';
import 'package:visivallet/features/contacts/database/data_sources/contact_data_source.dart';
import 'package:visivallet/features/contacts/database/repositories/contact_repository.dart';
import 'package:visivallet/features/contacts/database/repositories/contact_repository_impl.dart';
import 'package:visivallet/features/event/database/data_sources/event_contact_data_source.dart';
import 'package:visivallet/features/event/database/data_sources/event_data_source.dart';
import 'package:visivallet/features/event/database/repositories/event_repository.dart';
import 'package:visivallet/features/event/database/repositories/event_repository_impl.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// ##############
// ### EVENTS ###
// ##############

final eventDataSourceProvider = Provider<EventDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return EventDataSource(database);
});

final eventContactDataSourceProvider = Provider<EventContactDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return EventContactDataSource(database);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final eventDataSource = ref.watch(eventDataSourceProvider);
  final relationshipDataSource = ref.watch(eventContactDataSourceProvider);
  return EventRepositoryImpl(eventDataSource, relationshipDataSource);
});

// Provider for all events
final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getAllEvents();
});

// Provider for filtered events
final filteredEventsProvider = FutureProvider.family<List<Event>, String>((ref, filter) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getAllEventsFiltered(filter);
});

// Provider for a single event
final eventProvider = FutureProvider.family<Event?, int>((ref, id) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEventById(id);
});

// Provider for contacts in an event
final eventContactsProvider = FutureProvider.family<List<Contact>, int>((ref, eventId) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getContactsForEvent(eventId);
});

// Provider for filtered contacts in an event
final filteredEventContactsProvider = FutureProvider.family<List<Contact>, Map<String, dynamic>>((ref, args) async {
  final eventId = args['eventId'] as int;
  final filter = args['filter'] as String;
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getContactsForEventFiltered(eventId, filter);
});

// Provider for events that a contact belongs to
final contactEventsProvider = FutureProvider.family<List<Event>, int>((ref, contactId) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEventsForContact(contactId);
});

// ################
// ### CONTACTS ###
// ################

// Provider for the contact data source
final contactDataSourceProvider = Provider<ContactDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ContactDataSource(database);
});

// Provider for filtered contacts
final filteredContactsProvider = FutureProvider.family<List<Contact>, String>((ref, filter) async {
  final repository = ref.watch(contactRepositoryProvider);
  return repository.getAllContactsFiltered(filter);
});

// Provider for a single contact
final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final contactDataSource = ref.watch(contactDataSourceProvider);
  return ContactRepositoryImpl(contactDataSource);
});

// Provider for all contacts
final contactsProvider = FutureProvider<List<Contact>>((ref) async {
  final repository = ref.watch(contactRepositoryProvider);
  return repository.getAllContacts();
});
