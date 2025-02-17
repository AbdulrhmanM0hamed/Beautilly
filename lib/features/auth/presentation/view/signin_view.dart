import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/services/cache/cache_service_impl.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/signin_view_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = "login";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Provider<CacheService>(
          create: (_) => CacheServiceImpl(snapshot.data!),
          child: const Scaffold(
            appBar: CustomAppBar(
              title: AppStrings.login,
            ),
            body: SigninViewBody(),
          ),
        );
      },
    );
  }
}
