import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Discover/presentation/view/discover_view.dart';
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

  final List<Widget> _pages = [
    const HomeViewBody(),
    const DiscoverView(),
    const Scaffold(body: Center(child: Text('الحجوزات'))),
    const Scaffold(body: Center(child: Text('الرسائل'))),
    const Scaffold(body: Center(child: Text('حسابي'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey,
            selectedLabelStyle: getMediumStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
            unselectedLabelStyle: getMediumStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
            items: [
              _buildNavItem(AppAssets.homeIconBottom, 'الرئيسية'),
              _buildNavItem(AppAssets.Location, 'الأقرب'),
              _buildNavItem(AppAssets.calendarIconBottom, 'الحجوزات'),
              _buildNavItem(AppAssets.subtractIcon, 'الرسائل'),
              _buildNavItem(AppAssets.profileIconBottom, 'حسابي'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
            _selectedIndex == _getIndexForLabel(label)
                ? AppColors.primary
                : AppColors.grey,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }

  int _getIndexForLabel(String label) {
    switch (label) {
      case 'الرئيسية':
        return 0;
      case 'الأقرب':
        return 1;
      case 'الحجوزات':
        return 2;
      case 'الرسائل':
        return 3;
      case 'حسابي':
        return 4;
      default:
        return 0;
    }
  }
}
