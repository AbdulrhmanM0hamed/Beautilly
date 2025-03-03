import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';

class HomeSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const HomeSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: TextField(
          controller: _searchController,
          textAlignVertical: TextAlignVertical.center,
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            hintText: ' ابحث عن صالون  او  دار ازياء ...',
            hintStyle: getMediumStyle(
              color: AppColors.grey,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 25 , left: 8),
              child: SvgPicture.asset(
                AppAssets.searchIcon,
                width: 30,
                height: 30,
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
    );
  }
}
