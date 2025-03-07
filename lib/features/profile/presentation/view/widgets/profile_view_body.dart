import 'package:flutter/material.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_header.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_menu_section.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_stats_section.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ProfileHeader(),
          ProfileStatsSection(),
          ProfileMenuSection(),
        ],
      ),
    );
  }
}
