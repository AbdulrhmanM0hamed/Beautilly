
import 'package:beautilly/features/Home/presentation/cubit/service_shops_cubit/service_shops_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../core/services/service_locator.dart';
import '../../domain/entities/service.dart';
import '../widgets/service_details/service_header.dart';
import '../widgets/service_details/service_shop_card.dart';
import '../widgets/service_details/service_description.dart';
import '../cubit/service_shops_cubit/service_shops_cubit.dart';
import 'package:beautilly/core/utils/shimmer/service_shop_card_shimmer.dart';

class ServiceDetailsView extends StatelessWidget {
  final ServiceEntity service;

  const ServiceDetailsView({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<ServiceShopsCubit>();
        cubit.loadShopsByIds(service.shops.map((shop) => shop.id).toList());
        return cubit;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Header with service image and details
            ServiceHeader(service: service),

            // Service description
            SliverToBoxAdapter(
              child: ServiceDescription(service: service),
            ),
            // Shops Grid

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: BlocBuilder<ServiceShopsCubit, ServiceShopsState>(
                builder: (context, state) {
                  if (state is ServiceShopsLoading) {
                    return SliverToBoxAdapter(
                      child: MasonryGridView.count(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        itemCount: 4,
                        itemBuilder: (context, index) =>
                            const ServiceShopCardShimmer(),
                      ),
                    );
                  }

                  if (state is ServiceShopsLoaded) {
                    return SliverToBoxAdapter(
                      child: MasonryGridView.count(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        itemCount: state.shops.length,
                        itemBuilder: (context, index) => ServiceShopCard(
                          shop: state.shops[index],
                        ),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
