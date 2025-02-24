import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/common/custom_dialog_button.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/rating_cubit/rating_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/rating_cubit/rating_state.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/salon_profile_cubit/salon_profile_cubit.dart';

class SalonReviewsSection extends StatelessWidget {
  final RatingsSummary ratings;
  final int salonId;
  final bool hasRated;

  const SalonReviewsSection({
    super.key,
    required this.ratings,
    required this.salonId,
    required this.hasRated,
  });

  void _showAddRatingDialog(BuildContext context) {
    int selectedRating = 5;
    final commentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final salonProfileCubit = context.read<SalonProfileCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: salonProfileCubit),
          BlocProvider(create: (_) => GetIt.I<RatingCubit>()),
        ],
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'إضافة تقييم',
                    style: getBoldStyle(
                      fontSize: FontSize.size18,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 32,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      selectedRating = rating.toInt();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'اكتب تعليقك هنا...',
                      border: const OutlineInputBorder(),
                      errorStyle: getMediumStyle(
                        fontSize: FontSize.size12,
                        color: Colors.red,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يجب كتابة تعليق مع التقييم';
                      }
                      if (value.trim().length < 3) {
                        return 'التعليق قصير جداً';
                      }
                      if (value.trim().length > 150) {
                        return 'التعليق طويل جداً';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocConsumer<RatingCubit, RatingState>(
                    listener: (context, state) {
                      if (state is RatingSuccess) {
                        salonProfileCubit.getSalonProfile(salonId);
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (context.mounted) {
                            Navigator.pop(context);
                            CustomSnackbar.showSuccess(
                              context: context,
                              message: 'تم إضافة تقييمك بنجاح',
                            );
                          }
                        });
                      } else if (state is RatingError) {
                        CustomSnackbar.showError(
                          context: context,
                          message: state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: CustomDialogButton(
                              text: 'إلغاء',
                              onPressed: () => Navigator.pop(context),
                              isDestructive: true,
                              backgroundColor: Colors.white,
                              textColor: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomDialogButton(
                              text: state is RatingLoading ? '' : 'إرسال',
                              onPressed: state is RatingLoading
                                  ? null
                                  : () {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        if (selectedRating < 1) {
                                          CustomSnackbar.showError(
                                            context: context,
                                            message: 'يجب اختيار تقييم',
                                          );
                                          return;
                                        }
                                        context.read<RatingCubit>().addRating(
                                              shopId: salonId,
                                              rating: selectedRating,
                                              comment:
                                                  commentController.text.trim(),
                                            );
                                      }
                                    },
                              backgroundColor: AppColors.primary,
                              textColor: Colors.white,
                              isLoading: state is RatingLoading,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteRatingDialog(BuildContext context) {
    final salonProfileCubit = context.read<SalonProfileCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: salonProfileCubit,
          ),
          BlocProvider(
            create: (_) => GetIt.I<RatingCubit>(),
          ),
        ],
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'حذف التقييم',
                  style: getBoldStyle(
                    fontSize: FontSize.size18,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'هل أنت متأكد من حذف تقييمك؟',
                  style: getMediumStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<RatingCubit, RatingState>(
                  listener: (context, state) {
                    if (state is RatingDeleted) {
                      salonProfileCubit.getSalonProfile(salonId);

                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (context.mounted) {
                          Navigator.pop(context);
                          CustomSnackbar.showSuccess(
                            context: context,
                            message: 'تم حذف التقييم بنجاح',
                          );
                        }
                      });
                    } else if (state is RatingError) {
                      CustomSnackbar.showError(
                        context: context,
                        message: state.message,
                      );
                    }
                  },
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomDialogButton(
                            text: 'إلغاء',
                            onPressed: () => Navigator.pop(context),
                            backgroundColor: Colors.white,
                            textColor: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomDialogButton(
                            text: 'حذف',
                            onPressed: state is RatingLoading
                                ? null
                                : () {
                                    context
                                        .read<RatingCubit>()
                                        .deleteRating(salonId);
                                  },
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            isLoading: state is RatingLoading,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
              const Spacer(),
              if (hasRated)
                TextButton.icon(
                  onPressed: () => _showDeleteRatingDialog(context),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: Text(
                    'حذف التقييم',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: Colors.red,
                    ),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: () => _showAddRatingDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(
                    'إضافة تقييم',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                    ),
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
          ...ratings.ratings.map((review) => _buildReviewCard(context, review)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Rating review) {
    final isUserRating = review.user.id == sl<CacheService>().getUserId();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://dallik.com/storage/${review.user.avatar}" ??
                                '',
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
                              if (isUserRating)
                                Text(
                                  '  (أنت)',
                                  style: getSemiBoldStyle(
                                    color: AppColors.grey,
                                    fontSize: FontSize.size16,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
                              const Spacer(),
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
                          if (review.comment != null &&
                              review.comment!.isNotEmpty)
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
