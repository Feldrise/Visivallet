import 'package:flutter/material.dart';
import 'package:visivallet/core/dialogs/closable_dialog.dart';
import 'package:visivallet/features/event/widgets/event_form.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final GlobalKey<EventFormState> _formKey = GlobalKey<EventFormState>();

  @override
  Widget build(BuildContext context) {
    return ClosableDialog(
      title: "Ajouter un évenement",
      actions: [
        TextButton.icon(
          onPressed: () => _formKey.currentState?.save(),
          label: const Text("Ajouter"),
        ),
      ],
      child: EventForm(
        key: _formKey,
      ),
    );
  }
}
