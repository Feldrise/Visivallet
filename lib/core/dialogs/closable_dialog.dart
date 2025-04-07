import 'package:flutter/material.dart';
import 'package:visivallet/theme/screen_helper.dart';
import 'dialog_header.dart';

class ClosableDialog extends StatelessWidget {
  const ClosableDialog({super.key, required this.title, required this.child, this.actions = const [], this.maxWidth = 670, this.isClosable = true});

  final String title;
  final Widget child;
  final List<Widget> actions;

  final double maxWidth;

  final bool isClosable;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.all(ScreenHelper.instance.horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The header
            DialogHeader(
              title: title,
              isClosable: isClosable,
            ),
            const SizedBox(
              height: 12,
            ),

            // The content
            Flexible(
              child: child,
            ),
            const SizedBox(
              height: 20,
            ),

            // The actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            )
          ],
        ),
      ),
    );
  }
}
