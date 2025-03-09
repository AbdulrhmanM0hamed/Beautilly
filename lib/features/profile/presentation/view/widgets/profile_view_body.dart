import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_header.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_menu_section.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/profile_stats_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: sl<CacheService>().isGuestMode(),
      builder: (context, snapshot) {
        final bool isGuest = snapshot.data ?? false;
        
        return RefreshIndicator(
          onRefresh: () async {
            // Add your refresh logic here
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const ProfileHeader(),
                if (!isGuest) const ProfileStatsSection(),
                const ProfileMenuSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
