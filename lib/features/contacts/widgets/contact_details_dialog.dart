import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/core/widgets/success_snackbar.dart';
import 'package:visivallet/features/company/providers/company_provider.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/phone_contacts_provider.dart';
import 'package:visivallet/features/contacts/services/contact_sharing_service.dart';
import 'package:visivallet/features/contacts/services/phone_contacts_service.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactDetailsDialog extends ConsumerWidget {
  const ContactDetailsDialog({
    super.key,
    required this.contact,
    this.onUpdated,
  });

  final Contact contact;
  final void Function()? onUpdated;

  Future<void> _addToContacts(BuildContext context, WidgetRef ref) async {
    LoadingOverlay.of(context).show();

    try {
      // Use the dedicated service to add the contact to the phone
      await ref.read(phoneContactsServiceProvider).addContactToPhone(contact);

      onUpdated?.call();
      if (context.mounted) {
        SuccessSnackbar.show(context, "Contact ajouté à votre répertoire");
        Navigator.of(context).pop();
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

  void _makePhoneCall(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: contact.phone);
    if (await url_launcher.canLaunchUrl(phoneUri)) {
      await url_launcher.launchUrl(phoneUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Impossible de lancer l'appel téléphonique"),
          ),
        );
      }
    }
  }

  void _sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: contact.email,
      queryParameters: {'subject': 'Contact depuis Visivallet'},
    );

    if (await url_launcher.canLaunchUrl(emailUri)) {
      await url_launcher.launchUrl(emailUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Impossible d'ouvrir le client email"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactSharingService = ref.read(contactSharingServiceProvider);
    final qrData = contactSharingService.generateQRData(contact);

    // Use the service to check if the contact exists in phone
    final bool contactExistsInPhone = ref.read(phoneContactsServiceProvider).contactExistsInPhone(contact);

    // Get company if companyId is available
    final companyState = contact.companyId != null ? ref.watch(companyByIdProvider(contact.companyId!)) : null;
    final companyName = companyState?.value?.name;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with close button
            Stack(
              children: [
                // Contact image or placeholder
                FutureBuilder(
                  future: contact.getImage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 200,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasData) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      );
                    }

                    // Placeholder with gradient background
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary.withOpacity(0.7),
                            Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    );
                  },
                ),

                // Close button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),

            // Contact info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Company
                  Text(
                    "${contact.firstName} ${contact.lastName}",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (companyName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      companyName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Contact Details
                  _buildContactDetailItem(
                    context: context,
                    icon: Icons.email,
                    title: "Email",
                    value: contact.email,
                    onTap: () => _sendEmail(context),
                  ),
                  const Divider(),
                  _buildContactDetailItem(
                    context: context,
                    icon: Icons.phone,
                    title: "Téléphone",
                    value: contact.phone,
                    onTap: () => _makePhoneCall(context),
                  ),

                  const SizedBox(height: 24),

                  // QR Code
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "QR Code",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 150.0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        context: context,
                        icon: Icons.share,
                        label: "Partager",
                        onPressed: () => _shareContact(context, ref),
                        primary: true,
                      ),
                      if (!contactExistsInPhone)
                        _buildActionButton(
                          context: context,
                          icon: Icons.person_add_outlined,
                          label: "Ajouter aux contacts",
                          onPressed: () => _addToContacts(context, ref),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactDetailItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool primary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? Theme.of(context).colorScheme.primary : null,
        foregroundColor: primary ? Theme.of(context).colorScheme.onPrimary : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }
}
