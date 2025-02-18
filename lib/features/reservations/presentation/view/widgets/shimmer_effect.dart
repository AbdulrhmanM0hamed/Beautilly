import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const ShimmerEffect({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }
} 