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
import 'package:beautilly/core/utils/responsive/app_responsive.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppResponsive.mobileBreakpoint;
        final padding = AppResponsive.getScreenProportion(16);
        final titleSize = isTablet ? FontSize.size24 : FontSize.size20;

        return BlocConsumer<StatisticsCubit, StatisticsState>(
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
                      fontSize: titleSize,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  SizedBox(height: padding),
                  StatisticsShimmer(),
                ],
              );
            }

            if (state is StatisticsLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات دلالك',
                    style: getBoldStyle(
                      fontSize: titleSize,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  SizedBox(height: padding),
                  _StatisticsGrid(statistics: state.statistics),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  final StatisticsModel statistics;

  const _StatisticsGrid({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dimensions = ResponsiveCardSizes.getCardDimensions(context, constraints);

        return SizedBox(
          height: dimensions.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                'عميل سعيد',
                statistics.happyClients,
                Icons.people_outline,
                AppColors.primary,
                dimensions.width,
              ),
              SizedBox(width: dimensions.spacing),
              _buildStatCard(
                'خدمة متنوعة',
                statistics.services,
                Icons.spa_outlined,
                AppColors.secondary,
                dimensions.width,
              ),
              SizedBox(width: dimensions.spacing),
              _buildStatCard(
                'دار أزياء',
                statistics.fashionHouses,
                Icons.shopping_bag_outlined,
                AppColors.accent,
                dimensions.width,
              ),
              SizedBox(width: dimensions.spacing),
              _buildStatCard(
                'صالون تجميل',
                statistics.beautySalons,
                Icons.store_outlined,
                Colors.purple,
                dimensions.width,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color, double width) {
    return SizedBox(
      width: width,
      child: StatisticCard(
        title: title,
        value: value,
        icon: icon,
        color: color,
      ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizes = ResponsiveCardSizes.getInternalSizes(constraints);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: ResponsiveCardSizes.getPadding(sizes),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.15),
                  borderRadius: ResponsiveCardSizes.defaultBorderRadius,
                  border: Border.all(
                    color: widget.color.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          widget.icon,
                          color: widget.color,
                          size: sizes.iconSize,
                        ),
                        SizedBox(
                          width: sizes.progressSize,
                          height: sizes.progressSize,
                          child: CircularProgressIndicator(
                            value: _controller.value,
                            strokeWidth: sizes.progressStrokeWidth,
                            backgroundColor: widget.color.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    FittedBox(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: sizes.titleSize,
                          fontWeight: FontWeight.w600,
                          color: widget.color,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: sizes.verticalPadding * 1),

                    FittedBox(
                      child: Text(
                        _valueAnimation.value.toInt().toString(),
                        style: TextStyle(
                          fontSize: sizes.valueSize,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
