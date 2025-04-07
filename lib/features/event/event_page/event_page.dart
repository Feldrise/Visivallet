import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/shimmers/square_shimmer.dart';
import 'package:visivallet/features/contacts/add_contact_page/add_contact_page.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/widgets/contact_card.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/theme/screen_helper.dart';

class EventPage extends ConsumerWidget {
  final int eventId;

  const EventPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventProvider(eventId));
    final contactsState = ref.watch(eventContactsProvider(eventId));

    if (eventState.isLoading) {
      return Scaffold(
        body: Column(
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
        ),
      );
    }

    if (eventState.hasError) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
          child: Center(
            child: Text(
              "Une erreur est survenue : ${eventState.error}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    final Event event = eventState.value!;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Builder(builder: (context) {
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

        return ListView(
          children: [
            for (final contact in contacts) ...[
              ContactCard(contact: contact),
              const SizedBox(height: 8),
            ]
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Contact? contact = await Navigator.of(context).push<Contact?>(
            MaterialPageRoute<Contact?>(
              builder: (context) => AddContactPage(event: event),
            ),
          );

          if (contact != null) {
            ref.invalidate(eventContactsProvider(eventId));
            ref.invalidate(contactsProvider);
          }
        },
        child: const Icon(Icons.person_add_outlined),
      ),
    );
  }
}
