import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/salon_profile_cubit/salon_profile_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/salon_profile_cubit/salon_profile_state.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalonProfileView extends StatelessWidget {
  final int salonId;

  const SalonProfileView({
    super.key,
    required this.salonId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SalonProfileCubit>()..getSalonProfile(salonId),
      child: Scaffold(
        body: BlocBuilder<SalonProfileCubit, SalonProfileState>(
          builder: (context, state) {
            if (state is SalonProfileLoading) {
              return const Center(
                  child: CustomProgressIndcator(
                color: AppColors.primary,
              ));
            }

            if (state is SalonProfileError) {
              return Center(child: Text(state.message));
            }

            if (state is SalonProfileLoaded) {
              return SalonProfileViewBody(profile: state.profile);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
