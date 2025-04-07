import 'package:flutter/material.dart';
import 'package:visivallet/features/contacts/widgets/contact_form.dart';
import 'package:visivallet/features/event/models/event/event.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final GlobalKey<ContactFormState> _contactFormKey = GlobalKey<ContactFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un contact"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _contactFormKey.currentState?.save(),
          ),
        ],
      ),
      body: ContactForm(
        key: _contactFormKey,
        event: widget.event,
      ),
    );
  }
}
