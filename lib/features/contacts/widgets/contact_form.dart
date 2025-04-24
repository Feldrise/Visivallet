import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:visivallet/core/dialogs/confirmation_dialog.dart';
import 'package:visivallet/core/form_validator.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/error_snackbar.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/core/widgets/success_snackbar.dart';
import 'package:visivallet/features/contacts/database/repositories/contact_repository.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/phone_contacts_provider.dart';
import 'package:visivallet/features/event/database/repositories/event_repository.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/theme/screen_helper.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as phc;

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
  final GlobalKey<ScalableOCRState> _ocrKey = GlobalKey<ScalableOCRState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final PhoneController _phoneController = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.FR, nsn: ""));

  bool _shouldScan = false;
  Uint8List? _image;

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
              if (_shouldScan) ...[
                SizedBox(
                  height: 260,
                  child: ScalableOCR(
                    key: _ocrKey,
                    paintboxCustom: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4.0
                      ..color = const Color.fromARGB(153, 102, 160, 241),
                    boxLeftOff: 10,
                    boxBottomOff: 10,
                    boxRightOff: 10,
                    boxTopOff: 10,
                    boxHeight: 200,
                    getRawData: (List<dynamic> value) {
                      for (var element in value) {
                        log("Element: ${element.text}");
                      }
                    },
                    getScannedText: (String value) {
                      Future.microtask(() {
                        log("Scanned Text: $value");
                        final String scannedText = value.toLowerCase();

                        // Split into lines first, then words
                        List<String> lines = scannedText.split('\n');
                        List<String> allWords = [];

                        // Collect all words from all lines
                        for (var line in lines) {
                          allWords.addAll(line.trim().split(' ').where((w) => w.isNotEmpty));
                        }

                        // Try to find first name and last name
                        if (_lastNameController.text.isEmpty && _firstNameController.text.isEmpty) {
                          // On ne garde que les tokens 100% alphabétiques (lettres et accents)
                          final nameWords = allWords.where((w) => RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ]+$').hasMatch(w)).toList();

                          String? detectedFirstName;
                          String? detectedLastName;

                          // On teste toutes les paires (ou triplets si tu veux gérer 3 mots)
                          for (int i = 0; i < nameWords.length - 1; i++) {
                            final w1 = nameWords[i];
                            final w2 = nameWords[i + 1];

                            // 1) Prénom en Title Case et nom en UPPERCASE
                            final isFirstName = RegExp(r'^[A-Z][a-zà-öø-ÿ]+$').hasMatch(w1);
                            final isLastName = RegExp(r'^[A-ZÀ-ÖØ-Ÿ]{2,}$').hasMatch(w2);

                            // 2) Ou les deux en Title Case (cas de « Jean Dupont »)
                            final bothTitleCase = RegExp(r'^[A-Z][a-zà-öø-ÿ]+$').hasMatch(w1) && RegExp(r'^[A-Z][a-zà-öø-ÿ]+$').hasMatch(w2);

                            if ((isFirstName && isLastName) || bothTitleCase) {
                              detectedFirstName = w1;
                              detectedLastName = w2;
                              break;
                            }
                          }

                          if (detectedFirstName != null && detectedLastName != null) {
                            _firstNameController.text = detectedFirstName;
                            _lastNameController.text = detectedLastName;
                          }
                        }

                        // Try to find email
                        if (_emailController.text.isEmpty) {
                          for (var line in lines) {
                            final emailMatch = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').firstMatch(line);
                            if (emailMatch != null) {
                              _emailController.text = emailMatch.group(0)!;
                              break;
                            }
                          }
                        }

                        // Try to find phone number
                        if (_phoneController.value.nsn.isEmpty) {
                          for (var line in lines) {
                            // Pattern for French numbers: supports formats like 06.59.34.27.17, 06 59 34 27 17, 0659342717
                            final phoneMatch = RegExp(r'(\+33|0)[\s.-]?[1-9][\s.-]?\d{2}[\s.-]?\d{2}[\s.-]?\d{2}[\s.-]?\d{2}').firstMatch(line);
                            if (phoneMatch != null) {
                              final phone = phoneMatch.group(0)!.replaceAll(RegExp(r'[\s.-]'), '');
                              try {
                                _phoneController.value = PhoneNumber(isoCode: IsoCode.FR, nsn: phone);
                              } catch (e) {
                                log("Could not parse phone number: $e");
                              }
                              break;
                            }
                          }
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Take picture button
                    FilledButton.icon(
                      onPressed: () async {
                        LoadingOverlay.of(context).show();
                        _image = await _ocrKey.currentState?.captureImage();
                        setState(() {
                          LoadingOverlay.of(context).hide();
                          _shouldScan = false;
                        });
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Prendre une photo"),
                    ),
                    const SizedBox(width: 8),
                    // Stop scanning button
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _shouldScan = false;
                        });
                      },
                      icon: const Icon(Icons.close),
                      label: const Text("Stoper le scan"),
                    ),
                  ],
                ),
              ] else
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _shouldScan = true;
                    });
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scanner email et téléphone"),
                ),
              const SizedBox(height: 12),
              if (_image != null) ...[
                Image.memory(
                  _image!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 12),
              ],
              // Text(
              //   key: UniqueKey(),
              //   "Resultat de la reconnaissance : $_ocrTextResult",
              // ),
              // const SizedBox(height: 12),
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
        imageBase64: _image != null ? base64Encode(_image!) : null,
      );

      final ContactRepository contactRepository = ref.read(contactRepositoryProvider);
      final EventRepository eventRepository = ref.read(eventRepositoryProvider);
      newContact = await contactRepository.createContact(newContact);
      if (widget.event != null) {
        await eventRepository.addContactToEvent(widget.event!.id!, newContact.id!);
      }

      final phc.Contact? existingContact = ref.read(phoneContactsProvider.notifier).getContactByPhoneNumber(newContact.phone);

      if (existingContact == null && mounted) {
        final bool shouldAddToContact = await showDialog<bool?>(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: "Ajouter le contact à votre répertoire ?",
                content: "Voulez-vous ajouter le contact ${newContact.firstName} ${newContact.lastName} à votre répertoire ?",
              ),
            ) ??
            false;

        if (shouldAddToContact) {
          final phc.Contact newPhoneContact = phc.Contact(
            displayName: "${newContact.firstName} ${newContact.lastName}",
            name: phc.Name(
              first: newContact.firstName,
              last: newContact.lastName,
            ),
            phones: [phc.Phone(newContact.phone)],
          );

          await ref.read(phoneContactsProvider.notifier).addContact(newPhoneContact);

          if (mounted) {
            SuccessSnackbar.show(context, "Contact ajouté à votre répertoire");
          }
        }
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
