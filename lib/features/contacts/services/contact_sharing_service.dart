import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visivallet/features/company/providers/company_provider.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/features/company/models/company/company.dart';

/// A service to handle contact sharing functionality
class ContactSharingService {
  final Ref _ref;

  ContactSharingService(this._ref);

  /// Shares a contact using the native share dialog
  Future<void> shareContact(Contact contact) async {
    // Generate vCard content
    String vCardContent = await _generateVCard(contact);

    // Get app documents directory
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${contact.lastName}_${contact.firstName}.vcf';

    // Create a file with vCard content
    final File file = File(filePath);
    await file.writeAsString(vCardContent);

    // Share the file
    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Contact: ${contact.firstName} ${contact.lastName}',
      subject: 'Contact Information',
    );
  }

  /// Shares multiple contacts using the native share dialog
  Future<void> shareMultipleContacts(List<Contact> contacts) async {
    if (contacts.isEmpty) return;

    // Get app documents directory
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/contacts.vcf';

    // Generate vCard content for all contacts
    String allVCards = '';
    for (var contact in contacts) {
      allVCards += await _generateVCard(contact);
    }

    // Create a file with vCard content
    final File file = File(filePath);
    await file.writeAsString(allVCards);

    // Share the file
    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Contacts (${contacts.length})',
      subject: 'Contact Information',
    );
  }

  /// Generate vCard 3.0 format for a contact
  Future<String> _generateVCard(Contact contact) async {
    StringBuffer vCard = StringBuffer();

    // Start vCard
    vCard.writeln('BEGIN:VCARD');
    vCard.writeln('VERSION:3.0');

    // Add name
    vCard.writeln('N:${contact.lastName};${contact.firstName};;;');
    vCard.writeln('FN:${contact.firstName} ${contact.lastName}');

    // Add company if available
    if (contact.companyId != null) {
      Company? company = await _ref.read(companyByIdProvider(contact.companyId!).future);
      if (company != null) {
        vCard.writeln('ORG:${company.name}');
      }
    }

    // Add contact details
    vCard.writeln('EMAIL:${contact.email}');
    vCard.writeln('TEL:${contact.phone}');

    // End vCard
    vCard.writeln('END:VCARD');

    return vCard.toString();
  }

  /// Generate QR code data for a contact
  String generateQRData(Contact contact) {
    // Create a simple map with contact data
    final Map<String, dynamic> contactMap = {
      'firstName': contact.firstName,
      'lastName': contact.lastName,
      'email': contact.email,
      'phone': contact.phone,
      'companyId': contact.companyId,
      'imageBase64': contact.imageBase64,
      'qrCodeType': 'visivallet-contact',
    };

    // Convert to JSON and return as the QR code data
    return jsonEncode(contactMap);
  }

  /// Parse contact data from QR code
  Contact? parseContactQRData(String qrData) {
    try {
      final Map<String, dynamic> contactMap = jsonDecode(qrData) as Map<String, dynamic>;

      // Verify this is a valid Visivallet contact QR code
      if (contactMap['qrCodeType'] != 'visivallet-contact') {
        return null;
      }

      // Create and return a contact from the map
      return Contact(
        firstName: (contactMap['firstName'] as String?) ?? '',
        lastName: (contactMap['lastName'] as String?) ?? '',
        email: (contactMap['email'] as String?) ?? '',
        phone: (contactMap['phone'] as String?) ?? '',
        imageBase64: ((contactMap['imageBase64'] as String?) ?? '').isNotEmpty ? contactMap['imageBase64'] as String? : null,
      );
    } catch (e) {
      return null;
    }
  }
}

final contactSharingServiceProvider = Provider<ContactSharingService>((ref) {
  return ContactSharingService(ref);
});
