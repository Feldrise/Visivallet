import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/dialogs/confirmation_dialog.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/core/widgets/shimmers/square_shimmer.dart';
import 'package:visivallet/features/event/events_page/widgets/event_card.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/theme/screen_helper.dart';

class EventsList extends ConsumerWidget {
  const EventsList({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = searchQuery.isEmpty ? ref.watch(eventsProvider) : ref.watch(filteredEventsProvider(searchQuery));

    if (eventsState.isLoading) {
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

    if (eventsState.hasError) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
        child: Center(
          child: Text(
            "Une erreur est survenue : ${eventsState.error}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final List<Event> events = eventsState.value ?? [];

    if (events.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              "Aucun événement trouvé",
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
        for (final Event event in events) ...[
          EventCard(event: event, onDelete: () => _deleteEvent(context, ref, event: event)),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Future<void> _deleteEvent(
    BuildContext context,
    WidgetRef ref, {
    required Event event,
  }) async {
    if (event.id == null) {
      return;
    }

    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => const ConfirmationDialog(
            title: "Supprimer l'événement",
            content: "Êtes-vous sûr de vouloir supprimer cet événement ?",
            isDeletationConfirmation: true,
          ),
        ) ??
        false;

    if (confirmed == true) {
      if (context.mounted) {
        LoadingOverlay.of(context).show();
      }

      final eventRepository = ref.read(eventRepositoryProvider);
      await eventRepository.deleteEvent(event.id!);

      ref.invalidate(eventsProvider);

      if (context.mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }
}
