import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/add_review_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SalonReviewsSection extends StatelessWidget {
  const SalonReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with rating summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقييمات',
                style: getBoldStyle(
                  fontSize: FontSize.size20,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const AddReviewBottomSheet(),
                  );
                },
                child: Text(
                  'إضافة تقييم',
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // Rating Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '4.8',
                      style: getBoldStyle(
                        fontSize: FontSize.size30,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: 4.8,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      ignoreGestures: true,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    Text(
                      'من 245 تقييم',
                      style: getMediumStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.8),
                      _buildRatingBar(4, 0.15),
                      _buildRatingBar(3, 0.03),
                      _buildRatingBar(2, 0.01),
                      _buildRatingBar(1, 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reviews List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) => _buildReviewCard(reviews[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: getMediumStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: getMediumStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(.1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(review.userImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: getBoldStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: review.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          ignoreGestures: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review.date,
                          style: getMediumStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewModel {
  final String userName;
  final String userImage;
  final double rating;
  final String date;
  final String comment;

  ReviewModel({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

final List<ReviewModel> reviews = [
  ReviewModel(
    userName: 'سارة أحمد',
    userImage: AppAssets.test,
    rating: 5.0,
    date: 'منذ 3 أيام',
    comment:
        'خدمة ممتازة وطاقم عمل محترف جداً. سعيدة جداً بالنتيجة وأنصح الجميع بتجربة خدماتهم.',
  ),
  ReviewModel(
    userName: 'نورا محمد',
    userImage: AppAssets.test,
    rating: 4.5,
    date: 'منذ أسبوع',
    comment:
        'تجربة رائعة والنتيجة كانت أفضل من توقعاتي. سأعود مرة أخرى بالتأكيد.',
  ),
  ReviewModel(
    userName: 'ريم خالد',
    userImage: AppAssets.test,
    rating: 5.0,
    date: 'منذ أسبوعين',
    comment:
        'الصالون نظيف جداً والموظفات محترفات. أسعار معقولة مقابل جودة الخدمة.',
  ),
];
