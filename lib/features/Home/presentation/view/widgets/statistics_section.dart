import 'package:beautilly/core/utils/shimmer/statistics_shimmer.dart';
import 'package:beautilly/features/Home/data/models/statistics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import '../../../../../core/utils/widgets/custom_snackbar.dart';
import '../../cubit/statistics_cubit/statistics_cubit.dart';
import '../../cubit/statistics_cubit/statistics_state.dart';
import 'package:beautilly/core/services/service_locator.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StatisticsCubit>()..getStatistics(),
      child: BlocConsumer<StatisticsCubit, StatisticsState>(
        listener: (context, state) {
          if (state is StatisticsError) {
            CustomSnackbar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return Column(
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
                StatisticsShimmer(),
              ],
            );
          }

          if (state is StatisticsLoaded) {
            final stats = state.statistics;
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
                  _StatisticsGrid(statistics: stats),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  final StatisticsModel statistics;

  const _StatisticsGrid({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.1,

      children: [
        StatisticCard(
          title: 'عميل سعيد',
          value: statistics.happyClients,
          icon: Icons.people_outline,
          color: AppColors.primary,
        ),
        StatisticCard(
          title: 'خدمة متنوعة',
          value: statistics.services,
          icon: Icons.spa_outlined,
          color: AppColors.secondary,
        ),
        StatisticCard(
          title: 'دار أزياء',
          value: statistics.fashionHouses,
          icon: Icons.shopping_bag_outlined,
          color: AppColors.accent,
        ),
        StatisticCard(
          title: 'صالون تجميل',
          value: statistics.beautySalons,
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
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(widget.icon, color: widget.color, size: 24),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 2,
                        backgroundColor: widget.color.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  widget.title,
                  style: getMediumStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  _valueAnimation.value.toInt().toString(),
                  style: getBoldStyle(
                    fontSize: FontSize.size16,
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
