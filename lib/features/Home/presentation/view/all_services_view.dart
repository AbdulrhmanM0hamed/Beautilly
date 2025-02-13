import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/services_grid_view.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';

class AllServicesView extends StatelessWidget {
  static const String routeName = '/all-services';
  
  const AllServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getServiceGridDimensions(context);

    return BlocProvider(
      create: (context) => sl<ServicesCubit>()..loadServices(),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'كل الخدمات'),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(dimensions.padding),
              child: Column(
                children: [
                  ServicesGridView(maxItems: 100), // عدد كبير لعرض كل الخدمات
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
