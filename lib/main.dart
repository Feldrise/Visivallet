import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visivallet/core/widgets/splash_screen.dart';
import 'package:visivallet/features/contacts/phone_contacts_provider.dart';
import 'package:visivallet/features/main_page/router.dart';
import 'package:visivallet/theme/theme.dart';
import 'package:visivallet/theme/util.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved theme preference
  final prefs = await SharedPreferences.getInstance();
  final String? themePreference = prefs.getString('themeMode');

  ThemeMode initialThemeMode = ThemeMode.system;
  if (themePreference == 'dark') {
    initialThemeMode = ThemeMode.dark;
  } else if (themePreference == 'light') {
    initialThemeMode = ThemeMode.light;
  }

  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith((ref) => initialThemeMode),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Sora", "Sora");

    final themeMode = ref.watch(themeModeProvider);
    final MaterialTheme theme = MaterialTheme(textTheme);

    return FutureBuilder(
        future: ref.read(phoneContactsProvider.notifier).init(),
        builder: (context, snaphsot) {
          if (snaphsot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snaphsot.hasError) {
            return const Center(
              child: Text("Erreur lors du chargement des contacts"),
            );
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: theme.light(),
            darkTheme: theme.dark(),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [
              Locale('fr', 'FR'),
            ],
            routerConfig: router(),
          );
        });
  }
}
