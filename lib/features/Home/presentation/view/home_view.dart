import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/home_view_body.dart';
import 'package:beautilly/features/nearby/presentation/view/discover_view.dart';
import 'package:beautilly/features/profile/presentation/view/profile_view.dart';
import 'package:beautilly/features/orders/presentation/view/orders_requests_view.dart';
import 'package:beautilly/features/reservations/presentation/view/reservations_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../cubit/service_cubit/services_cubit.dart';
import '../cubit/statistics_cubit/statistics_cubit.dart';
import '../cubit/premium_shops_cubit/premium_shops_cubit.dart';
import '../cubit/discounts_cubit/discounts_cubit.dart';
import 'package:beautilly/core/utils/responsive/app_responsive.dart';
import 'package:beautilly/core/utils/responsive/responsive_layout.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/home';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final _pageController = PageController();

  final List<Widget> _pages = [
    const KeepAlivePage(child: HomeViewBody()),
    const KeepAlivePage(child: DiscoverView()),
    const KeepAlivePage(child: ReservationsView()),
    const KeepAlivePage(child: OrdersRequestsView()),
    KeepAlivePage(child: ProfileView()),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تهيئة الـ responsive values
    AppResponsive().init(context);

    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ServicesCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<StatisticsCubit>()..getStatistics(),
        ),
        BlocProvider(
          create: (context) => sl<PremiumShopsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<DiscountsCubit>(),
        ),
     
      ],
      child: BlocProvider(
        create: (context) {
          final cubit = sl<ProfileCubit>();

          if (!cubit.isClosed) {
            final currentProfile = cubit.currentProfile;
            if (currentProfile == null) {
              cubit.loadProfile();
            }
          } else {
            sl.unregister<ProfileCubit>();
            sl.registerFactory<ProfileCubit>(
                () => ProfileCubit(repository: sl()));
            final newCubit = sl<ProfileCubit>();
            newCubit.loadProfile();
            return newCubit;
          }

          return cubit;
        },
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
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
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() => _currentIndex = index);
                  _pageController.jumpToPage(index);
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
                  _buildNavItem(AppAssets.tfsel, 'طلبات'),
                  _buildNavItem(AppAssets.profileIconBottom, 'حسابي'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    // Implementation for tablet layout
    return _buildMobileLayout();
  }

  Widget _buildDesktopLayout() {
    // Implementation for desktop layout
    return _buildMobileLayout();
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
            _currentIndex == _getIndexForLabel(label)
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
      case 'طلبات':
        return 3;
      case 'حسابي':
        return 4;
      default:
        return 0;
    }
  }
}

class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({
    super.key,
    required this.child,
  });

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
