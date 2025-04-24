import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneContactsProvider = StateNotifierProvider<PhoneContactsProvider, List<Contact>>(
  (ref) => PhoneContactsProvider(),
);

class PhoneContactsProvider extends StateNotifier<List<Contact>> {
  PhoneContactsProvider() : super([]);

  Future<void> init() async {
    if (await FlutterContacts.requestPermission()) {
      final List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );

      state = contacts;
    }
  }

  Future<void> addContact(Contact contact) async {
    await contact.insert();
    // Add a new contact to the state
    state = [...state, contact];
  }

  Contact? getContactByPhoneNumber(String phoneNumber) {
    return state.firstWhereOrNull(
      (contact) => contact.phones.any((phone) {
        // Normalize phone numbers by removing all non-digit characters
        var normalizedContactNumber = phone.number.replaceAll(RegExp(r'[^\d]'), '');
        var normalizedSearchNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

        // Direct match
        if (normalizedContactNumber == normalizedSearchNumber) {
          return true;
        }

        // Handle French numbers: convert 06/07 to +33 format and vice versa
        if (normalizedContactNumber.startsWith('33') && normalizedSearchNumber.startsWith('0')) {
          // Compare +33 format with 0 format
          return normalizedContactNumber.substring(2) == normalizedSearchNumber.substring(1);
        } else if (normalizedSearchNumber.startsWith('33') && normalizedContactNumber.startsWith('0')) {
          // Compare 0 format with +33 format
          return normalizedSearchNumber.substring(2) == normalizedContactNumber.substring(1);
        }

        return false;
      }),
    );
  }
}

extension on List<Contact> {
  Contact? firstWhereOrNull(bool Function(Contact contact) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
