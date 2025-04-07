import 'package:visivallet/features/contacts/database/data_sources/contact_data_source.dart';
import 'package:visivallet/features/contacts/database/repositories/contact_repository.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactDataSource _contactDataSource;

  ContactRepositoryImpl(this._contactDataSource);

  // Contact operations
  @override
  Future<List<Contact>> getAllContacts() {
    return _contactDataSource.getAllContacts();
  }

  @override
  Future<Contact?> getContactById(int id) {
    return _contactDataSource.getContactById(id);
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    final id = await _contactDataSource.createContact(contact);
    return contact.copyWith(id: id);
  }

  @override
  Future<bool> updateContact(Contact contact) async {
    final result = await _contactDataSource.updateContact(contact);
    return result > 0;
  }

  @override
  Future<bool> deleteContact(int id) async {
    final result = await _contactDataSource.deleteContact(id);
    return result > 0;
  }
}
