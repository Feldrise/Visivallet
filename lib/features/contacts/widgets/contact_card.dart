import 'package:flutter/material.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${contact.firstName} ${contact.lastName}"),
      subtitle: Text(contact.email),
      onTap: () {
        // Handle contact tap
      },
    );
  }
}
