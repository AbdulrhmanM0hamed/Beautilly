import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SalonReviewsSection extends StatelessWidget {
  final RatingsSummary ratings;

  const SalonReviewsSection({
    super.key,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    // حساب عدد التقييمات لكل نجمة بشكل صحيح
    Map<int, int> ratingCounts = {
      5: 0,
      4: 0,
      3: 0,
      2: 0,
      1: 0,
    };

    // حساب عدد كل تقييم
    for (final review in ratings.ratings) {
      if (ratingCounts.containsKey(review.rating)) {
        ratingCounts[review.rating] = ratingCounts[review.rating]! + 1;
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'التقييمات',
                style: getBoldStyle(
                  fontSize: FontSize.size20,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ratings.average.toStringAsFixed(1),
                      style: getBoldStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      ' (${ratings.count})',
                      style: getMediumStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Rating Bars
          ...List.generate(5, (index) {
            final stars = 5 - index;
            final count =
                ratingCounts[stars]!; // استخدام ! لأننا متأكدين من وجود المفتاح
            final percentage =
                ratings.count > 0 ? (count / ratings.count) * 100 : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '$stars',
                      style: getMediumStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.star,
                    color: AppColors.accent,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        // Background Bar
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Filled Bar
                        FractionallySizedBox(
                          widthFactor: percentage / 100,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '($count)',
                      style: getMediumStyle(
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).reversed.toList(),

          const SizedBox(height: 16),

          // Reviews List
          ...ratings.ratings.map((review) => _buildReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Rating review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info & Rating
          Row(
            children: [
              // User Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://dallik.com/storage/${review.user.avatar}" ?? '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // User Name & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.user.name,
                          style: getBoldStyle(
                            fontSize: FontSize.size16,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: AppColors.accent,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                    Text(
                      review.createdAt.toString(),
                      style: getMediumStyle(
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.comment!,
                      style: getMediumStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating Stars
            ],
          ),

          // Comment Section
          // if (review.comment != null && review.comment!.isNotEmpty) ...[
          //   const SizedBox(height: 8),
          //   Container(
          //     margin: const EdgeInsets.only(
          //       right: 48,
          //     ), // نفس عرض الصورة + المسافة
          //     child: Text(
          //       review.comment!,
          //       style: getMediumStyle(
          //         fontSize: FontSize.size14,
          //         fontFamily: FontConstant.cairo,
          //       ),
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}
