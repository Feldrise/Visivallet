import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/features/event/dialogs/add_event_dialog.dart';
import 'package:visivallet/features/event/events_page/widgets/events_list.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/theme/screen_helper.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evenements"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenHelper.instance.horizontalPadding,
              vertical: 8,
            ),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Rechercher un événement",
                hintText: "Titre ou description",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _debounceSearch,
            ),
          ),
          Expanded(
            child: EventsList(searchQuery: _searchQuery),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Event? newEvent = await showDialog<Event>(context: context, builder: (context) => const LoadingOverlay(child: AddEventDialog()));

          if (newEvent != null) {
            ref.invalidate(eventsProvider);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
