import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VwNavigationBar extends StatelessWidget {
  const VwNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    if (GoRouterState.of(context).uri.toString().startsWith("/contacts")) {
      currentIndex = 1;
    } else if (GoRouterState.of(context).uri.toString().startsWith("/profile")) {
      currentIndex = 2;
    }

    return NavigationBar(
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go("/");
            break;
          case 1:
            context.go("/contacts");
            break;
          case 2:
            context.go("/profile");
            break;
        }
      },
      selectedIndex: currentIndex,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.local_activity_outlined),
          selectedIcon: Icon(Icons.local_activity),
          label: "Evenements",
        ),
        const NavigationDestination(
          icon: Icon(Icons.contacts_outlined),
          selectedIcon: Icon(Icons.contacts),
          label: "Contacts",
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }
}
