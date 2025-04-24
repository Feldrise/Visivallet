import 'package:flutter/material.dart';
import 'package:visivallet/theme/theme.dart';
import 'package:visivallet/theme/util.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Sora", "Sora");

    final MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      theme: theme.light(),
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(96 / 2),
              ),
              width: 96,
              height: 96,
              child: Icon(
                Icons.wallet_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
