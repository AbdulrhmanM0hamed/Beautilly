import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/shimmer/service_card_shimmer.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/domain/entities/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/service_cubit/services_cubit.dart';
import '../../cubit/service_cubit/services_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServicesGridView extends StatefulWidget {
  final int maxItems;

  const ServicesGridView({
    super.key,
    this.maxItems = 8,
  });

  @override
  State<ServicesGridView> createState() => _ServicesGridViewState();
}

class _ServicesGridViewState extends State<ServicesGridView> {
  @override
  void initState() {
    super.initState();
    // تحميل الخدمات عند بداية عرض الـ widget
    context.read<ServicesCubit>().loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return ServicesGridShimmer();
        }

        if (state is ServicesLoaded) {
          final services = state.services.take(widget.maxItems).toList();
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.05,
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) => ServiceCard(
              service: services[index],
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

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // التنقل إلى صفحة تفاصيل الخدمة
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة الخدمة
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    // الصورة الرئيسية
                    AspectRatio(
                      aspectRatio: 1.5,
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: service.type == 'salon'
                              ? AppColors.primary
                              : Colors.purple,
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
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              service.type == 'salon' ? 'صالون' : 'دار ازياء',
                              style: getMediumStyle(
                                fontFamily: FontConstant.cairo,
                                color: Colors.white,
                                fontSize: FontSize.size10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // عدد المتاجر
                    if (service.shops.isNotEmpty)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.store_outlined,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${service.shops.length} متجر',
                                style: getMediumStyle(
                                  fontFamily: FontConstant.cairo,
                                  color: Colors.white,
                                  fontSize: FontSize.size10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // اسم الخدمة
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  service.name,
                  style: getBoldStyle(
                    fontSize: FontSize.size13,
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
}
