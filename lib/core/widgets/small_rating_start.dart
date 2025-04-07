import 'package:flutter/material.dart';

class SmallRatingStart extends StatelessWidget {
  const SmallRatingStart({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.star,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ],
    );
  }
}
