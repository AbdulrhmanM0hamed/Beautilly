import 'package:beautilly/core/utils/shimmer/service_card_shimmer.dart';
import 'package:beautilly/features/Home/domain/entities/service.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';
import 'package:beautilly/features/Home/presentation/view/service_details_view.dart';

class ServicesGridView extends StatefulWidget {
  final int maxItems;

  const ServicesGridView({
    super.key,
    required this.maxItems,
  });

  @override
  State<ServicesGridView> createState() => _ServicesGridViewState();
}

class _ServicesGridViewState extends State<ServicesGridView> {
  @override
  void initState() {
    super.initState();
    // تحميل الخدمات عند بداية تحميل الـ widget
    context.read<ServicesCubit>().getServices();
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getServiceGridDimensions(context);

    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return const ServicesGridShimmer();
        }

        if (state is ServicesError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is ServicesLoaded) {
          if (state.services.isEmpty) {
            return const Center(
              child: Text('لا توجد نتائج'),
            );
          }

          final services = state.services.take(widget.maxItems).toList();
          return SizedBox(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: dimensions.crossAxisCount,
                childAspectRatio: dimensions.childAspectRatio,
                crossAxisSpacing: dimensions.spacing,
                mainAxisSpacing: dimensions.spacing,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) => ServiceCard(
                service: services[index],
                dimensions: dimensions,
              ),
            ),
          );
        }

        return const SizedBox();
      },
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
    return Container(
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceDetailsView(service: service),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة الخدمة
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(dimensions.borderRadius),
                ),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.8,
                      child: CachedNetworkImage(
                        imageUrl: service.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: const Icon(Icons.error_outline),
                        ),
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
