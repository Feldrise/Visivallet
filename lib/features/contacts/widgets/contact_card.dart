import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/core/widgets/success_snackbar.dart';
import 'package:visivallet/features/company/providers/company_provider.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/phone_contacts_provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as phc;

class ContactCard extends ConsumerWidget {
  const ContactCard({
    super.key,
    required this.contact,
  });

  final Contact contact;

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
            trailing: phoneContact == null
                ? IconButton(
                    onPressed: () async {
                      LoadingOverlay.of(context).show();

                      final phc.Contact newContact = phc.Contact(
                        displayName: "${contact.firstName} ${contact.lastName}",
                        name: phc.Name(
                          first: contact.firstName,
                          last: contact.lastName,
                        ),
                        phones: [phc.Phone(contact.phone)],
                      );

                      await ref.read(phoneContactsProvider.notifier).addContact(newContact);

                      if (context.mounted) {
                        LoadingOverlay.of(context).hide();
                        SuccessSnackbar.show(context, "Contact ajouté à votre répertoire");
                      }
                    },
                    icon: const Icon(Icons.person_add_outlined),
                  )
                : null,
            onTap: () {
              // Handle contact tap
            },
          ),
        ],
      ),
    );
  }
}
