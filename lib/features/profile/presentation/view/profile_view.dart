import 'package:flutter/material.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_view_body.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const String routeName = 'profile-view';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: "حسابي",
        automaticallyImplyLeading: false,
      ),
      body: ProfileViewBody(),
    );
  }
}
