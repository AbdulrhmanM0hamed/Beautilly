import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../cubit/service_cubit/services_cubit.dart';

class ServicesSearchBar extends StatelessWidget {
  const ServicesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(-2, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              onChanged: (query) {
                if (query.isNotEmpty) {
                  context.read<ServicesCubit>().searchServices(query);
                } else {
                  context.read<ServicesCubit>().getServices();
                }
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن خدمة...',
                hintStyle: getMediumStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    // Clear search text and refresh services
                    context.read<ServicesCubit>().getServices();
                  },
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
