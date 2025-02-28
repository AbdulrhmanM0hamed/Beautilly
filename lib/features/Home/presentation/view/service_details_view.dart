import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../domain/entities/service_entity.dart';
import '../widgets/service_details/service_shop_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beautilly/core/utils/common/image_viewer.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class ServiceDetailsView extends StatelessWidget {
  final ServiceEntity service;

  const ServiceDetailsView({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getServiceDetailsGridDimensions(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
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
            title: Text(
              service.name,
              style: getBoldStyle(
                fontSize: FontSize.size18,
                fontFamily: FontConstant.cairo,
                color: Colors.white,
              ),
            ),
            flexibleSpace: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageViewer(imageUrl: service.image),
                ),
              ),
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
                              Colors.black.withOpacity(0.3),
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
          SliverPadding(
            padding: EdgeInsets.all(dimensions.padding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                Text(
                  'المتاجر التي تقدم هذه الخدمة',
                  style: getBoldStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 16),
                MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: dimensions.crossAxisCount,
                  mainAxisSpacing: dimensions.mainAxisSpacing,
                  crossAxisSpacing: dimensions.crossAxisSpacing,
                  itemCount: service.shops.length,
                  itemBuilder: (context, index) => ServiceShopCard(
                    shop: service.shops[index],
                    dimensions: dimensions,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
