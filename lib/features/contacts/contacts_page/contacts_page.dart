import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/shimmers/square_shimmer.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/widgets/contact_card.dart';
import 'package:visivallet/theme/screen_helper.dart';

class ContactsPage extends ConsumerWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          final contactsState = ref.watch(contactsProvider);

          if (contactsState.isLoading) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < 5; i++) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
                    child: const SquareShimmer(height: 80),
                  ),
                ],
              ],
            );
          }

          if (contactsState.hasError) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
              child: Center(
                child: Text(
                  "Une erreur est survenue : ${contactsState.hasError}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          final List<Contact> contacts = contactsState.value ?? [];

          if (contacts.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.contacts_outlined,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Aucun contact trouvé",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
            children: [
              for (final contact in contacts) ...[
                ContactCard(contact: contact),
                const SizedBox(height: 8),
              ]
            ],
          );
        },
      ),
    );
  }
}
