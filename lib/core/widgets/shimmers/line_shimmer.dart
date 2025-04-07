import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LineShimmer extends StatelessWidget {
  const LineShimmer({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(height / 2),
        ),
        height: height,
      ),
    );
  }
}
