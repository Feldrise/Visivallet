import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/features/contacts/add_contact_page/add_contact_page.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/scan_qr_page/scan_qr_page.dart';
import 'package:visivallet/features/contacts/widgets/contacts_list.dart';
import 'package:visivallet/theme/screen_helper.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  String? _searchQuery = "";
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _debounceSearch(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _searchQuery = value;
      });
    });
  }

  Future<void> _scanQRCode() async {
    final Contact? contact = await Navigator.of(context).push<Contact?>(
      MaterialPageRoute<Contact?>(
        builder: (context) => const ScanQRPage(),
      ),
    );

    if (contact != null) {
      ref.invalidate(contactsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanQRCode,
            tooltip: "Scanner un QR Code",
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenHelper.instance.horizontalPadding,
              vertical: 8,
            ),
            child: TextField(
                decoration: const InputDecoration(
                  labelText: "Rechercher un contact",
                  hintText: "Nom, prénom, numéro de téléphone ou email",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _debounceSearch),
          ),
          Expanded(
            child: ContactsList(
              searchQuery: _searchQuery,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Contact? contact = await Navigator.of(context).push<Contact?>(
            MaterialPageRoute<Contact?>(
              builder: (context) => const AddContactPage(event: null),
            ),
          );

          if (contact != null) {
            ref.invalidate(contactsProvider);
          }
        },
        child: const Icon(Icons.person_add_outlined),
      ),
    );
  }
}
