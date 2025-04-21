import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/features/contacts/widgets/contacts_list.dart';
import 'package:visivallet/theme/screen_helper.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  String? _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        centerTitle: true,
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
              onChanged: (value) => setState(() {
                _searchQuery = value;
              }),
            ),
          ),
          Expanded(
            child: ContactsList(
              searchQuery: _searchQuery,
            ),
          ),
        ],
      ),
    );
  }
}
