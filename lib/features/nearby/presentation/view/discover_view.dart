import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/nearby/presentation/cubit/search_shops_cubit.dart';
import 'package:beautilly/features/nearby/presentation/view/widgets/discover_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchShopsCubit>(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: DiscoverViewBody(),
      ),
    );
  }
}
