import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../domain/entities/search_result.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult searchResult;
  final VoidCallback? onTap;

  const SearchResultCard({
    super.key,
    required this.searchResult,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 120,
            child: Row(
              children: [
                Stack(
                  children: [
                    // Shop Image
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: searchResult.mainShopImageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                    // Favorite Button
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withValues(alpha:0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: searchResult.userInteractions.hasLiked
                              ? Colors.red
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              searchResult.name,
                              style: getBoldStyle(
                                fontSize: FontSize.size16,
                                fontFamily: FontConstant.cairo,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.location,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.grey,
                                    BlendMode.srcIn,
                                  ),
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${searchResult.cityName}, ${searchResult.stateName}',
                                    style: getRegularStyle(
                                      fontSize: FontSize.size12,
                                      fontFamily: FontConstant.cairo,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha:0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                searchResult.type == 'salon'
                                    ? 'صالون'
                                    : 'دار ازياء',
                                style: getMediumStyle(
                                  color: AppColors.primary,
                                  fontSize: FontSize.size12,
                                  fontFamily: FontConstant.cairo,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  searchResult.avgRating.toStringAsFixed(1),
                                  style: getMediumStyle(
                                    fontSize: FontSize.size12,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
