import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/shimmer/nearby_service_card_shimmer.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/search_shops_cubit.dart';
import '../../cubit/search_shops_state.dart';
import 'nearby_service_card.dart';

class DiscoverBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final Function(double latitude, double longitude)? onLocationSelect;

  const DiscoverBottomSheet({
    super.key,
    required this.scrollController,
    this.onLocationSelect,
  });

  @override
  _DiscoverBottomSheetState createState() => _DiscoverBottomSheetState();
}

class _DiscoverBottomSheetState extends State<DiscoverBottomSheet> {
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchShopsCubit, SearchShopsState>(
      listener: (context, state) {
        if (state is SearchShopsLoading && state is! SearchShopsLoaded) {
          setState(() {
            _currentPage = 1;
            _hasMoreData = true;
          });
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.5,
        maxChildSize: 0.98,
        snap: true,
        snapSizes: const [0.5, 0.9, 0.98],
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!_isLoadingMore &&
                          _hasMoreData &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        _loadMoreData();
                      }
                      return true;
                    },
                    child: BlocBuilder<SearchShopsCubit, SearchShopsState>(
                      builder: (context, state) {
                        if (state is SearchShopsLoading && _currentPage == 1) {
                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: NearbyServiceCardShimmer(),
                              );
                            },
                          );
                        }

                        if (state is SearchShopsError && _currentPage == 1) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: AppColors.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _getErrorMessage(state.message),
                                  textAlign: TextAlign.center,
                                  style: getMediumStyle(
                                    fontSize: FontSize.size14,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
                                if (_isNetworkError(state.message))
                                  TextButton(
                                    onPressed: () {
                                      context.read<SearchShopsCubit>().filterShops();
                                    },
                                    child: const Text('إعادة المحاولة'),
                                  ),
                              ],
                            ),
                          );
                        }

                        if (state is SearchShopsLoaded) {
                          _hasMoreData =
                              _currentPage < state.pagination.lastPage;

                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount:
                                state.shops.length + (_hasMoreData ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == state.shops.length) {
                                return _isLoadingMore
                                    ? const Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: NearbyServiceCardShimmer(),
                                      )
                                    : const SizedBox();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: NearbyServiceCard(
                                  shop: state.shops[index],
                                  onLocationTap: widget.onLocationSelect,
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
      ),
    );
  }

  void _loadMoreData() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    await context.read<SearchShopsCubit>().loadMoreShops(page: _currentPage);

    setState(() {
      _isLoadingMore = false;
    });
  }

  String _getErrorMessage(String error) {
    if (_isNetworkError(error)) {
      return 'لا يمكن الاتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى';
    }
    
    return 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';
  }

  bool _isNetworkError(String error) {
    return error.contains('اتصال') || 
           error.contains('الإنترنت') || 
           error.contains('الشبكة');
  }
}
