import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/services/service_locator.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../../features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import '../../../../../features/profile/presentation/cubit/profile_cubit/profile_state.dart';
import '../../../../../features/profile/presentation/view/edit_address/edit_address_view.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: sl<CacheService>().isGuestMode(),
      builder: (context, snapshot) {
        final bool isGuest = snapshot.data ?? false;

        if (isGuest) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha:0.15),
                      AppColors.primary.withValues(alpha:0.05),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha:0.1),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _handleLocationTap(context, state),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildLocationIcon(),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      state is ProfileLoaded &&
                                              state.profile.city != null
                                          ? '${state.profile.state!.name}، ${state.profile.city!.name}'
                                          : 'موقعك الحالي',
                                      style: getBoldStyle(
                                        color: AppColors.primary,
                                        fontSize: FontSize.size14,
                                        fontFamily: FontConstant.cairo,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(تغيير)',
                                      style: getMediumStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: FontSize.size12,
                                        fontFamily: FontConstant.cairo,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'غيّر موقعك لتصلك العروض والخدمات والمتاجر القريبة منك',
                                  style: getRegularStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: FontSize.size12,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLocationIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha:0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.location_on_outlined,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }

  void _handleLocationTap(BuildContext context, ProfileState state) {
    if (state is ProfileLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditAddressView(
            profile: state.profile,
          ),
        ),
      );
    } else {
      CustomSnackbar.showSuccess(
        context: context,
        message: 'جاري تحميل بياناتك...',
      );
    }
  }
}
