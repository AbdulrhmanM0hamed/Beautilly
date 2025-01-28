import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_view_body.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const String routeName = 'profile-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "حسابي",
        automaticallyImplyLeading: false,
      ),
      body: MultiProvider(
        providers: [
          Provider<AuthRepository>.value(value: sl<AuthRepository>()),
          BlocProvider(create: (context) => sl<AuthCubit>()),
        ],
        child: const ProfileViewBody(),
      ),
    );
  }
}
