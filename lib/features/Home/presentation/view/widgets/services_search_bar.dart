import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../cubit/service_cubit/services_cubit.dart';
import '../../../../../core/utils/validators/form_validators.dart';

class ServicesSearchBar extends StatefulWidget {
  const ServicesSearchBar({super.key});

  @override
  State<ServicesSearchBar> createState() => _ServicesSearchBarState();
}

class _ServicesSearchBarState extends State<ServicesSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    final error = FormValidators.validateServiceSearch(query);
    if (error != null) {
      return;
    }

    if (query.isNotEmpty) {
      context.read<ServicesCubit>().searchServices(query);
    } else {
      context.read<ServicesCubit>().loadServices();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ServicesCubit>().loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha:0.2),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: _searchController,
              textAlignVertical: TextAlignVertical.center,
              onChanged: _handleSearch,
              decoration: InputDecoration(
                hintText: 'ابحث عن خدمة...',
                hintStyle: getMediumStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    AppAssets.searchIcon,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    return Visibility(
                      visible: value.text.isNotEmpty,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        onPressed: _clearSearch,
                      ),
                    );
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
