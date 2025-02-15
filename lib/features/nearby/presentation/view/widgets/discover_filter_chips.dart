import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/shop_type.dart';
import '../../cubit/search_shops_cubit.dart';
import '../../cubit/search_shops_state.dart';

class DiscoverFilterChips extends StatelessWidget {
  const DiscoverFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<SearchShopsCubit, SearchShopsState>(
        builder: (context, state) {
          final cubit = context.read<SearchShopsCubit>();
          return Row(
            children: [
              _buildFilterChip(
                ShopType.all.arabicName,
                cubit.selectedType == ShopType.all,
                context,
                () => cubit.changeType(ShopType.all),
              ),
              _buildFilterChip(
                ShopType.salon.arabicName,
                cubit.selectedType == ShopType.salon,
                context,
                () => cubit.changeType(ShopType.salon),
              ),
              _buildFilterChip(
                ShopType.tailor.arabicName,
                cubit.selectedType == ShopType.tailor,
                context,
                () => cubit.changeType(ShopType.tailor),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    BuildContext context,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(
          label,
          style: getMediumStyle(
            color: isSelected ? Colors.white : AppColors.grey,
            fontSize: FontSize.size12,
            fontFamily: FontConstant.cairo,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: const BorderSide(
          color: AppColors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        pressElevation: 0,
      ),
    );
  }
}
