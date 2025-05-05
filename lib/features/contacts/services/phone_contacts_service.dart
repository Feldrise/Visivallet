import 'package:flutter_contacts/flutter_contacts.dart' as phc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/features/company/models/company/company.dart';
import 'package:visivallet/features/company/providers/company_provider.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/phone_contacts_provider.dart';

/// Provider for the PhoneContactsService
final phoneContactsServiceProvider = Provider<PhoneContactsService>((ref) {
  return PhoneContactsService(ref);
});

/// A service to handle all operations related to phone contacts
class PhoneContactsService {
  final Ref _ref;

  PhoneContactsService(this._ref);

  /// Adds a Visivallet contact to the phone's contacts
  Future<void> addContactToPhone(Contact contact) async {
    // Check if we already have this contact in phone
    final existingContact = _ref.read(phoneContactsProvider.notifier).getContactByPhoneNumber(contact.phone);

    if (existingContact != null) {
      // Contact already exists, could update it if needed
      return;
    }

    // Create a new phone contact
    final phc.Contact newPhoneContact = phc.Contact(
      displayName: "${contact.firstName} ${contact.lastName}",
      name: phc.Name(
        first: contact.firstName,
        last: contact.lastName,
      ),
    );

    // Add phone number
    newPhoneContact.phones = [phc.Phone(contact.phone)];

    // Add email
    if (contact.email.isNotEmpty) {
      newPhoneContact.emails = [phc.Email(contact.email)];
    }

    // Add company if available
    if (contact.companyId != null) {
      try {
        final company = await _ref.read(companyByIdProvider(contact.companyId!).future);
        if (company != null) {
          newPhoneContact.organizations = [phc.Organization(company: company.name)];
        }
      } catch (e) {
        // Handle error or continue without company info
      }
    }

    // Insert the contact to phone
    await _ref.read(phoneContactsProvider.notifier).addContact(newPhoneContact);
  }

  /// Checks if a contact exists in the phone contacts
  bool contactExistsInPhone(Contact contact) {
    final existingContact = _ref.read(phoneContactsProvider.notifier).getContactByPhoneNumber(contact.phone);
    return existingContact != null;
  }
}
