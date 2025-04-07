import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/form_validator.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/error_snackbar.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/features/event/models/event/event.dart';

class EventForm extends ConsumerStatefulWidget {
  const EventForm({
    super.key,
    this.initialEvent,
  });

  final Event? initialEvent;

  @override
  ConsumerState<EventForm> createState() => EventFormState();
}

class EventFormState extends ConsumerState<EventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: "Titre",
              hintText: "Titre de l'événement",
            ),
            validator: FormValidator.requiredValidator,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: "Description (optionnelle)",
              hintText: "Description de l'événement",
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    LoadingOverlay.of(context).show();

    try {
      Event newEvent = Event(
        name: _titleController.text,
        description: _descriptionController.text,
      );

      final eventsRepository = ref.watch(eventRepositoryProvider);

      newEvent = await eventsRepository.createEvent(newEvent);

      if (mounted) {
        LoadingOverlay.of(context).hide();
        Navigator.of(context).pop(newEvent);
      }
    } on Exception catch (e) {
      if (mounted) {
        LoadingOverlay.of(context).hide();
        ErrorSnackbar.show(context, "Une erreur est survenue lors de l'ajout de l'événement : $e");
      }
    }
  }
}
