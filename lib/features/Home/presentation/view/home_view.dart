import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'home-view';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<({String icon, String label})> _items = [
    (icon: AppAssets.homeIconBottom, label: 'الرئيسية'),
    (icon: AppAssets.discoveryIcon, label: 'الاكتشاف'),
    (icon: AppAssets.subtractIcon, label: 'إضافة'),
    (icon: AppAssets.calendarIconBottom, label: 'المواعيد'),
    (icon: AppAssets.profileIconBottom, label: 'حسابي'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: const HomeViewBody()),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: getMediumStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
              ),
              unselectedLabelStyle: getMediumStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
              ),
              elevation: 0,
              items: _items
                  .map((item) => _buildNavItem(item.icon, item.label))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String icon, String label) {
    final isSelected = _items[_selectedIndex].icon == icon;
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: SvgPicture.asset(
          icon,
          height: 24,
          width: 24,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
      label: label,
    );
  }
}
