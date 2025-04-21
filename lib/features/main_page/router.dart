import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visivallet/features/contacts/contacts_page/contacts_page.dart';
import 'package:visivallet/features/event/event_page/event_page.dart';
import 'package:visivallet/features/event/events_page/events_page.dart';
import 'package:visivallet/features/main_page/main_page.dart';
import 'package:visivallet/features/user/profile_page/profile_page.dart';

CustomTransitionPage<dynamic> _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // return ScaleTransition(
      //   scale: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
      //   child: child,
      // );

      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}

GoRouter router() => GoRouter(
      routes: [
        ShellRoute(
          builder: (context, state, child) => MainPage(child: child),
          routes: [
            GoRoute(
              path: "/",
              builder: (context, state) => const EventsPage(),
              pageBuilder: (context, state) => _buildPageWithDefaultTransition<Object>(
                context: context,
                state: state,
                child: const EventsPage(),
              ),
              routes: [
                GoRoute(
                  path: "/event/:eventId",
                  builder: (context, state) => EventPage(eventId: int.parse(state.pathParameters["eventId"]!)),
                  pageBuilder: (context, state) => _buildPageWithDefaultTransition<Object>(
                    context: context,
                    state: state,
                    child: EventPage(eventId: int.parse(state.pathParameters["eventId"]!)),
                  ),
                )
              ],
            ),
            GoRoute(
              path: "/contacts",
              builder: (context, state) => const ContactsPage(),
              pageBuilder: (context, state) => _buildPageWithDefaultTransition<Object>(
                context: context,
                state: state,
                child: const ContactsPage(),
              ),
            ),
            GoRoute(
              path: "/profile",
              builder: (context, state) => const ProfilePage(),
              pageBuilder: (context, state) => _buildPageWithDefaultTransition<Object>(
                context: context,
                state: state,
                child: const ProfilePage(),
              ),
            )
          ],
        )
      ],
    );
