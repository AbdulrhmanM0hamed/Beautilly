import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';

import 'package:beautilly/features/Home/presentation/view/widgets/services_grid_view.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/services_search_bar.dart';

class AllServicesView extends StatelessWidget {
  const AllServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ServicesCubit>(),
      child: const AllServicesViewBody(),
    );
  }
}

class AllServicesViewBody extends StatelessWidget {
  const AllServicesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'كل الخدمات'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServicesSearchBar(),
              SizedBox(height: 16),
              ServicesGridView(
                maxItems: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
