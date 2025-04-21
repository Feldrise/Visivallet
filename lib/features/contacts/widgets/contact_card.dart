import 'package:flutter/material.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   title: Text("${contact.firstName} ${contact.lastName}"),
    //   subtitle: Text(contact.email),
    //   onTap: () {
    //     // Handle contact tap
    //   },
    // );
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
            title: Text("${contact.firstName} ${contact.lastName}"),
            subtitle: Text(contact.email),
            onTap: () {
              // Handle contact tap
            },
          ),
        ],
      ),
    );
  }
}
