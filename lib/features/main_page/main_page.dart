import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/features/main_page/widgets/navigation_bar.dart';
import 'package:visivallet/theme/screen_helper.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenHelper.instance.setValues(constraints.maxWidth);

        return LoadingOverlay(
          child: Scaffold(
            body: child,
            bottomNavigationBar: const VwNavigationBar(),
          ),
        );
      },
    );
  }
}
