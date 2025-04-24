import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visivallet/features/event/models/event/event.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onDelete,
  });

  final Event event;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          context.go("/event/${event.id}");
        },
        title: Text(
          event.name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        subtitle: Text(event.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onDelete(),
        ),
      ),
    );
  }
}
