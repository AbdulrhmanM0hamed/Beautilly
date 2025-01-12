import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_profile_view_body.dart';
import 'package:flutter/material.dart';

class SalonProfileView extends StatelessWidget {
  const SalonProfileView({super.key});
  static const String routeName = "Salon Profile";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SalonProfileViewBody(),
    );
  }
}
