import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/shimmers/square_shimmer.dart';
import 'package:visivallet/features/contacts/add_contact_page/add_contact_page.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/widgets/contacts_list.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/theme/screen_helper.dart';

class EventPage extends ConsumerStatefulWidget {
  final int eventId;

  const EventPage({super.key, required this.eventId});

  @override
  ConsumerState<EventPage> createState() => _EventPageState();
}

class _EventPageState extends ConsumerState<EventPage> {
  String _searchQuery = "";
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

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider(widget.eventId));

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
              onChanged: _debounceSearch,
            ),
          ),
          Expanded(
            child: ContactsList(
              event: event,
              searchQuery: _searchQuery,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Contact? contact = await Navigator.of(context).push<Contact?>(
            MaterialPageRoute<Contact?>(
              builder: (context) => AddContactPage(event: event),
            ),
          );

          if (contact != null) {
            ref.invalidate(eventContactsProvider(widget.eventId));
            ref.invalidate(contactsProvider);
          }
        },
        child: const Icon(Icons.person_add_outlined),
      ),
    );
  }
}
