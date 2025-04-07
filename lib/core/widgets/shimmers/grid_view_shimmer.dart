import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GridViewShimmer extends StatelessWidget {
  const GridViewShimmer({
    super.key,
    required this.itemCount,
    required this.maxCrossAxisExtent,
    this.itemHeight = 200,
  });

  final int itemCount;
  final double itemHeight;
  final double maxCrossAxisExtent;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          height: itemHeight,
        ),
      ),
    );
  }
}
