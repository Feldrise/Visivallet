import 'package:visivallet/features/contacts/models/contact/contact.dart';

abstract class ContactRepository {
  // Contact operations
  Future<List<Contact>> getAllContacts();
  Future<List<Contact>> getAllContactsFiltered(String filter);
  Future<Contact?> getContactById(int id);
  Future<Contact> createContact(Contact contact);
  Future<bool> updateContact(Contact contact);
  Future<bool> deleteContact(int id);
}
