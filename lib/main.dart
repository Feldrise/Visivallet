import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/features/main_page/router.dart';
import 'package:visivallet/theme/theme.dart';
import 'package:visivallet/theme/util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Sora", "Sora");

    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      routerConfig: router(),
    );
    // error: (e, _) => MaterialApp(
    //   theme: brightness == Brightness.light ? theme.light() : theme.dark(),
    //   home: Scaffold(
    //     body: Center(
    //       child: Text(
    //         e.toString(),
    //         style: textTheme.bodyLarge,
    //       ),
    //     ),
    //   ),
    // ),
    // loading: () => MaterialApp(
    //   theme: brightness == Brightness.light ? theme.light() : theme.dark(),
    //   home: const SplashScreen(),
    // ),
    // );
  }
}
