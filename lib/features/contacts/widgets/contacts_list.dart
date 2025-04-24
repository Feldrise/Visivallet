import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/shimmers/square_shimmer.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/widgets/contact_card.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/theme/screen_helper.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({
    super.key,
    this.event,
    this.searchQuery,
  });

  final Event? event;
  final String? searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsState = event == null
        ? (searchQuery ?? "").isEmpty
            ? ref.watch(contactsProvider)
            : ref.watch(filteredContactsProvider(searchQuery!))
        : (searchQuery ?? "").isEmpty
            ? ref.watch(eventContactsProvider(event!.id!))
            : ref.watch(filteredEventContactsProvider({
                "eventId": event!.id!,
                "filter": searchQuery!,
              }));

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
            "Une erreur est survenue : ${contactsState.error}",
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
      children: [
        for (final contact in contacts) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenHelper.instance.horizontalPadding,
            ),
            child: ContactCard(contact: contact),
          ),
          const SizedBox(height: 8),
        ]
      ],
    );
  }
}
