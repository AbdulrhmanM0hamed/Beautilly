import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات دلالك',
            style: getBoldStyle(
              fontSize: FontSize.size20,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 16),
          const _StatisticsGrid(),
        ],
      ),
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: const [
        StatisticCard(
          title: 'عميل سعيد',
          value: 15000,
          icon: Icons.people_outline,
          color: AppColors.primary,
        ),
        StatisticCard(
          title: 'خدمة متنوعة',
          value: 200,
          icon: Icons.spa_outlined,
          color: AppColors.secondary,
        ),
        StatisticCard(
          title: 'دار أزياء',
          value: 50,
          icon: Icons.shopping_bag_outlined,
          color: AppColors.accent,
        ),
        StatisticCard(
          title: 'صالون تجميل',
          value: 120,
          icon: Icons.store_outlined,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class StatisticCard extends StatefulWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<StatisticCard> createState() => _StatisticCardState();
}

class _StatisticCardState extends State<StatisticCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _valueAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _valueAnimation = Tween<double>(
      begin: 0,
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(widget.icon, color: widget.color, size: 35),
                    CircularProgressIndicator(
                      value: _controller.value,
                      strokeWidth: 2,
                      backgroundColor: widget.color.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  widget.title,
                  style: getMediumStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  _valueAnimation.value.toInt().toString(),
                  style: getBoldStyle(
                    fontSize: FontSize.size18,
                    fontFamily: FontConstant.cairo,
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
