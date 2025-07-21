import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import '../../cubit/user_statistics_cubit.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatisticsCubit, UserStatisticsState>(
      builder: (context, state) {
        if (state is UserStatisticsLoading) {
          return const _LoadingStats();
        }

        if (state is UserStatisticsLoaded) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(
                  icon: Icons.calendar_today_outlined,
                  value: state.statistics.reservationsCount,
                  label: 'الحجوزات',
                  color: AppColors.primary,
                ),
                _VerticalDivider(),
                _StatCard(
                  icon: Icons.design_services_outlined,
                  value: state.statistics.ordersCount,
                  label: 'طلبات التفصيل',
                  color: AppColors.secondary,
                ),
                _VerticalDivider(),
                _StatCard(
                  icon: Icons.favorite_border,
                  value: state.statistics.favoriteShopsCount,
                  label: 'المفضلة',
                  color: AppColors.error,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
      
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: getBoldStyle(
                fontSize: FontSize.size20,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.divider.withValues(alpha:0.5),
    );
  }
}

class _LoadingStats extends StatelessWidget {
  const _LoadingStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLoadingCard(context),
          _VerticalDivider(),
          _buildLoadingCard(context),
          _VerticalDivider(),
          _buildLoadingCard(context),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
       final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.grey[800]!.withValues(alpha:0.1) : Colors.grey.withValues(alpha:0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDark ?  Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 50,
              height: 12,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
