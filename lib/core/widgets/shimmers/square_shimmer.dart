import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SquareShimmer extends StatelessWidget {
  const SquareShimmer({
    super.key,
    required this.height,
    this.width,
  });

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        height: height,
        width: width,
      ),
    );
  }
}
