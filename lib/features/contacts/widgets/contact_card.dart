import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/dialogs/confirmation_dialog.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/core/widgets/success_snackbar.dart';
import 'package:visivallet/core/widgets/error_snackbar.dart';
import 'package:visivallet/features/company/providers/company_provider.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/phone_contacts_provider.dart';
import 'package:visivallet/features/contacts/services/contact_sharing_service.dart';
import 'package:visivallet/features/contacts/database/repositories/contact_repository.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as phc;

class ContactCard extends ConsumerWidget {
  const ContactCard({
    super.key,
    required this.contact,
    this.onUpdated,
  });

  final Contact contact;
  final Function()? onUpdated;

  Future<void> _addToContacts(BuildContext context, WidgetRef ref) async {
    LoadingOverlay.of(context).show();

    try {
      final phc.Contact newContact = phc.Contact(
        displayName: "${contact.firstName} ${contact.lastName}",
        name: phc.Name(
          first: contact.firstName,
          last: contact.lastName,
        ),
        phones: [phc.Phone(contact.phone)],
      );

      await ref.read(phoneContactsProvider.notifier).addContact(newContact);

      onUpdated?.call();
      if (context.mounted) {
        SuccessSnackbar.show(context, "Contact ajouté à votre répertoire");
      }
    } finally {
      if (context.mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }

  Future<void> _shareContact(BuildContext context, WidgetRef ref) async {
    LoadingOverlay.of(context).show();
    try {
      await ref.read(contactSharingServiceProvider).shareContact(contact);
      if (context.mounted) {
        SuccessSnackbar.show(context, "Contact partagé avec succès");
      }
    } finally {
      if (context.mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }

  Future<void> _deleteContact(BuildContext context, WidgetRef ref) async {
    if (contact.id == null) {
      ErrorSnackbar.show(context, "Impossible de supprimer ce contact");
      return;
    }

    final bool confirmed = await showDialog<bool?>(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: "Supprimer le contact",
            content: "Êtes-vous sûr de vouloir supprimer le contact ${contact.firstName} ${contact.lastName} ? Cette action est irréversible.",
            isDeletationConfirmation: true,
          ),
        ) ??
        false;

    if (!confirmed) return;

    if (context.mounted) {
      LoadingOverlay.of(context).show();
    }
    try {
      final contactRepository = ref.read(contactDataSourceProvider);
      await contactRepository.deleteContact(contact.id!);

      await Future<void>.delayed(const Duration(milliseconds: 500));
      onUpdated?.call();
      if (context.mounted) {
        SuccessSnackbar.show(context, "Contact supprimé avec succès");
        ref.invalidate(contactsProvider);
        ref.invalidate(eventContactsProvider);
      }
    } catch (e) {
      if (context.mounted) {
        ErrorSnackbar.show(context, "Erreur lors de la suppression : $e");
      }
    } finally {
      if (context.mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phc.Contact? phoneContact = ref.read(phoneContactsProvider.notifier).getContactByPhoneNumber(contact.phone);

    // Get company if companyId is available
    final companyState = contact.companyId != null ? ref.watch(companyByIdProvider(contact.companyId!)) : null;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FutureBuilder(
                future: contact.getImage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.error),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceDim,
                      padding: const EdgeInsets.all(16.0),
                      height: 150,
                      child: const Icon(Icons.image_not_supported),
                    );
                  }

                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  );
                }),
          ),
          ListTile(
            title: companyState != null
                ? Builder(
                    builder: (context) {
                      final String name = "${contact.firstName} ${contact.lastName}";
                      if (companyState.isLoading) {
                        return Text(name);
                      }
                      if (companyState.hasError) {
                        return Text(name);
                      }
                      return Text("$name (${companyState.value!.name})");
                    },
                  )
                : Text("${contact.firstName} ${contact.lastName}"),
            subtitle: Text(contact.email),
            trailing: MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => _shareContact(context, ref),
                  leadingIcon: const Icon(Icons.share),
                  child: const Text("Partager"),
                ),
                if (phoneContact == null)
                  MenuItemButton(
                    onPressed: () => _addToContacts(context, ref),
                    leadingIcon: const Icon(Icons.person_add_outlined),
                    child: const Text("Ajouter aux contacts"),
                  ),
                MenuItemButton(
                  onPressed: () => _deleteContact(context, ref),
                  leadingIcon: const Icon(Icons.delete),
                  child: const Text("Supprimer"),
                ),
              ],
              builder: (context, menuController, child) {
                return IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    if (menuController.isOpen) {
                      menuController.close();
                    } else {
                      menuController.open();
                    }
                  },
                );
              },
            ),
            onTap: () {
              // Handle contact tap
            },
          ),
        ],
      ),
    );
  }
}
