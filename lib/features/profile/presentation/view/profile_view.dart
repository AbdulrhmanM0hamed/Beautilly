import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_state.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_image_cubit/profile_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_view_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:beautilly/features/profile/presentation/cubit/user_statistics_cubit.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<UserStatisticsCubit>()..loadUserStatistics(),
        ),
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileCubit>()..loadProfile(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileImageCubit>(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<ProfileCubit>().loadProfile();
            context.read<UserStatisticsCubit>().loadUserStatistics();
          }
        },
        child: const ProfileViewContent(),
      ),
    );
  }
}

class ProfileViewContent extends StatelessWidget {
  const ProfileViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'حسابي',
        automaticallyImplyLeading: false,
      ),
      body:  ProfileViewBody(),
    );
  }
}
