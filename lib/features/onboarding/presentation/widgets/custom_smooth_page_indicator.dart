import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;
  final int currentPage;

  const CustomSmoothPageIndicator({
    super.key,
    required this.controller,
    required this.count,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index ? AppColors.primary : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ).toList().reversed.toList(), // تحويل ترتيب النقاط
    );
  }
}
