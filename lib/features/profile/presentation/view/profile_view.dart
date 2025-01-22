import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_view_body.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';
import 'package:beautilly/features/auth/data/repositories/auth_repository_impl.dart';
import 'widgets/profile_menu_section.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const String routeName = 'profile-view';

  @override
  Widget build(BuildContext context) {
    return Provider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(context.read<CacheService>()),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "حسابي",
          automaticallyImplyLeading: false,
        ),
        body: BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: ProfileViewBody(),
        ),
      ),
    );
  }
}
