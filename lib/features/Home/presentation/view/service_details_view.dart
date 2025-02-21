import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../domain/entities/service.dart';
import '../widgets/service_details/service_shop_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beautilly/core/utils/common/image_viewer.dart';

class ServiceDetailsView extends StatelessWidget {
  final ServiceEntity service;

  const ServiceDetailsView({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            pinned: true,
            flexibleSpace: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewer(
                      imageUrl: service.image,
                    ),
                  ),
                );
              },
              child: FlexibleSpaceBar(
                background: Hero(
                  tag: 'service_${service.id}',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: service.image,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // وصف الخدمة
                  Text(
                    service.description,
                    style: getRegularStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // عنوان المتاجر
                  Text(
                    'المتاجر التي تقدم هذه الخدمة',
                    style: getBoldStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // قائمة المتاجر
                  if (service.shops.isEmpty)
                    const Center(
                      child: Text('لا توجد متاجر متاحة حالياً'),
                    )
                  else
                    MasonryGridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: service.shops.length,
                      itemBuilder: (context, index) => ServiceShopCard(
                        shop: service.shops[index],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
