import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RoundShimmer extends StatelessWidget {
  const RoundShimmer({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(size / 2),
        ),
        height: size,
        width: size,
      ),
    );
  }
}
