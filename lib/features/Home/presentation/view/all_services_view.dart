import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';

import 'package:beautilly/features/Home/presentation/view/widgets/services_grid_view.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';

class AllServicesView extends StatelessWidget {
  const AllServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ServicesCubit>(),
      child: const Scaffold(
        appBar: CustomAppBar(title: 'كل الخدمات'),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ServicesGridView(), // سيعرض كل الخدمات لأننا لم نحدد maxItems
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
