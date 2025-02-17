import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/search_shops_cubit.dart';
import '../../cubit/search_shops_state.dart';
import 'nearby_service_card.dart';

class DiscoverBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final Function(double latitude, double longitude)? onLocationSelect;

  const DiscoverBottomSheet({
    super.key,
    required this.scrollController,
    this.onLocationSelect,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      snap: true,
      snapSizes: const [0.5, 0.9, 0.98],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'اسحب لأعلى لعرض المزيد',
                        style: getMediumStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  children: [
                    Text(
                      'الأقرب إليك',
                      style: getBoldStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: BlocBuilder<SearchShopsCubit, SearchShopsState>(
                    builder: (context, state) {
                      if (state is SearchShopsLoading) {
                        return const Center(
                          child: CustomProgressIndcator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      if (state is SearchShopsError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: getMediumStyle(
                              fontSize: FontSize.size14,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                        );
                      }

                      if (state is SearchShopsLoaded) {
                        if (state.shops.isEmpty) {
                          return Center(
                            child: Text(
                              'لا توجد نتائج',
                              style: getMediumStyle(
                                fontSize: FontSize.size14,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: state.shops.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: NearbyServiceCard(
                                shop: state.shops[index],
                                onLocationTap: onLocationSelect,
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                        child: Text(
                          'ابحث عن صالون أو دار أزياء',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
