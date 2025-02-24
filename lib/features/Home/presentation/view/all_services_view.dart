import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';
import 'package:beautilly/core/utils/shimmer/service_card_shimmer.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/domain/entities/service_entity.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/Home/presentation/view/service_details_view.dart';
import 'widgets/services_search_bar.dart';

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

class AllServicesViewBody extends StatefulWidget {
  const AllServicesViewBody({super.key});

  @override
  State<AllServicesViewBody> createState() => _AllServicesViewBodyState();
}

class _AllServicesViewBodyState extends State<AllServicesViewBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().loadServices();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.7) {
        final state = context.read<ServicesCubit>().state;
        if (state is ServicesLoaded && !state.isLastPage) {
          context.read<ServicesCubit>().loadMoreServices();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getServiceGridDimensions(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'كل الخدمات'),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: ServicesSearchBar(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<ServicesCubit>().loadServices();
              },
              child: BlocBuilder<ServicesCubit, ServicesState>(
                builder: (context, state) {
                  if (state is ServicesLoading && !state.isLoadingMore) {
                    return const AllServicesGridShimmer();
                  }
                  if (state is ServicesError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is ServicesLoaded) {
                    if (state.services.isEmpty) {
                      return const Center(child: Text('لا توجد خدمات'));
                    }
                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: dimensions.crossAxisCount,
                        childAspectRatio: dimensions.childAspectRatio,
                        crossAxisSpacing: dimensions.spacing,
                        mainAxisSpacing: dimensions.spacing,
                      ),
                      itemCount:
                          state.services.length + (state.isLastPage ? 0 : 4),
                      itemBuilder: (context, index) {
                        if (index >= state.services.length) {
                          return const ServiceCardShimmer();
                        }
                        return ServiceCard(
                          service: state.services[index],
                          dimensions: dimensions,
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceEntity service;
  final ServiceGridDimensions dimensions;

  const ServiceCard({
    super.key,
    required this.service,
    required this.dimensions,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRoutes.fadeScale(
            page: ServiceDetailsView(service: service),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(dimensions.borderRadius),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: service.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // نوع الخدمة
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildTypeChip(),
                  ),
                  // عدد المتاجر
                  if (service.shops.isNotEmpty)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: _buildShopsCountChip(),
                    ),
                ],
              ),
            ),
            // اسم الخدمة
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimensions.padding / 2,
                vertical: dimensions.padding / 1.5,
              ),
              child: Text(
                service.name,
                style: getBoldStyle(
                  fontSize: dimensions.titleSize,
                  fontFamily: FontConstant.cairo,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: service.type == 'salon' ? AppColors.primary : Colors.purple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            service.type == 'salon'
                ? Icons.spa_outlined
                : Icons.design_services_outlined,
            color: Colors.white,
            size: dimensions.iconSize * 0.65,
          ),
          const SizedBox(width: 4),
          Text(
            service.type == 'salon' ? 'صالون' : 'دار ازياء',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              color: Colors.white,
              fontSize: dimensions.titleSize * 0.85,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopsCountChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.store_outlined,
            color: Colors.white,
            size: dimensions.iconSize * 0.6,
          ),
          const SizedBox(width: 4),
          Text(
            '${service.shops.length} متجر',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              color: Colors.white,
              fontSize: dimensions.titleSize * 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
