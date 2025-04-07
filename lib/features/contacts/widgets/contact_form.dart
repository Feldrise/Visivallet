import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:visivallet/core/form_validator.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/error_snackbar.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/features/contacts/database/repositories/contact_repository.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/event/database/repositories/event_repository.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/theme/screen_helper.dart';

class ContactForm extends ConsumerStatefulWidget {
  const ContactForm({
    super.key,
    required this.event,
    this.initialContact,
  });

  final Event? event;
  final Contact? initialContact;

  @override
  ConsumerState<ContactForm> createState() => ContactFormState();
}

class ContactFormState extends ConsumerState<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final PhoneController _phoneController = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.FR, nsn: ""));

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenHelper.instance.horizontalPadding,
            vertical: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: "Prénom",
                          hintText: "Prénom",
                        ),
                        validator: FormValidator.requiredValidator,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: "Nom",
                          hintText: "Nom",
                        ),
                        validator: FormValidator.requiredValidator,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => FormValidator.emailValidator(value, isRequired: true),
              ),
              const SizedBox(height: 12),
              PhoneFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: "06 12 34 56 78",
                  labelText: "Numéro de téléphone",
                ),
                validator: (value) => FormValidator.phoneValidator(value, isRequired: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    LoadingOverlay.of(context).show();

    try {
      Contact newContact = Contact(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.value.international,
      );

      final ContactRepository contactRepository = ref.read(contactRepositoryProvider);
      final EventRepository eventRepository = ref.read(eventRepositoryProvider);
      newContact = await contactRepository.createContact(newContact);
      if (widget.event != null) {
        await eventRepository.addContactToEvent(widget.event!.id!, newContact.id!);
      }

      if (mounted) {
        LoadingOverlay.of(context).hide();
        Navigator.of(context).pop(newContact);
      }
    } on Exception catch (e) {
      if (mounted) {
        LoadingOverlay.of(context).hide();
        ErrorSnackbar.show(context, "Une erreur est survenue lors de l'ajout du contact : $e");
      }
    }
  }
}
