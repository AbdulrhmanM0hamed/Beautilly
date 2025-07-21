import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/home_view_body.dart';
import 'package:beautilly/features/nearby/presentation/cubit/search_shops_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_state.dart';
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
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'pages/search_page.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/home';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final _pageController = PageController();

  List<Widget> _getPages(bool isGuest) => [
        const KeepAlivePage(child: HomeViewBody()),
        if (!isGuest) ...[
          //   const KeepAlivePage(child: DiscoverView()),
          const KeepAlivePage(child: ReservationsView()),
          const KeepAlivePage(child: OrdersRequestsView()),
          const KeepAlivePage(child: ProfileView()),
        ],
      ];

  // Método para mostrar el bottom sheet de búsqueda
  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => sl<SearchCubit>(),
        child: const SearchPage(),
      ),
    );
  }

  Future<void> handleGuestSignIn(BuildContext context) async {
    try {
      // تسجيل خروج Guest
      await context.read<AuthCubit>().logout();

      if (!context.mounted) return;

      // مسح بيانات الملف الشخصي
      if (!context.read<ProfileCubit>().isClosed) {
        context.read<ProfileCubit>().clearProfile();
      }

      // التوجيه لصفحة تسجيل الدخول
      await Navigator.pushNamedAndRemoveUntil(
        context,
        SigninView.routeName,
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      // في حالة حدوث خطأ، التوجيه لصفحة تسجيل الدخول على أي حال
      await Navigator.pushNamedAndRemoveUntil(
        context,
        SigninView.routeName,
        (route) => false,
      );
    }
  }

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
        BlocProvider(
          create: (context) => sl<SearchCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SearchShopsCubit>()..filterShops(),
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
                () => ProfileCubit(cacheService: sl(), repository: sl()));
            final newCubit = sl<ProfileCubit>();
            newCubit.loadProfile();
            return newCubit;
          }

          return cubit;
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final bool isGuest = context.read<ProfileCubit>().isGuestUser;
            final pages = _getPages(isGuest);

            return Scaffold(
              body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showSearchBottomSheet(context),
                backgroundColor: AppColors.primary,
                elevation: 2,
                child: SvgPicture.asset(
                  AppAssets.searchIcon,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomAppBar(
                    height: 60,
                    padding: EdgeInsets.zero,
                    notchMargin: 8,
                    elevation: 0,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: const CircularNotchedRectangle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Icono de inicio
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() => _currentIndex = 0);
                              _pageController.jumpToPage(0);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.homeIconBottom,
                                  colorFilter: ColorFilter.mode(
                                    _currentIndex == 0
                                        ? AppColors.primary
                                        : AppColors.grey,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'الرئيسية',
                                  style: getMediumStyle(
                                    fontSize: FontSize.size12,
                                    fontFamily: FontConstant.cairo,
                                    color: _currentIndex == 0
                                        ? AppColors.primary
                                        : AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (isGuest)
                          // Icono de perfil para invitados
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, SigninView.routeName);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.profileIconBottom,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.grey,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'تسجيل الدخول',
                                    style: getMediumStyle(
                                      fontSize: FontSize.size12,
                                      fontFamily: FontConstant.cairo,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else ...[
                          // Icono de reservas
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() => _currentIndex = 1);
                                _pageController.jumpToPage(1);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.calendarIconBottom,
                                    colorFilter: ColorFilter.mode(
                                      _currentIndex == 1
                                          ? AppColors.primary
                                          : AppColors.grey,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'الحجوزات',
                                    style: getMediumStyle(
                                      fontSize: FontSize.size12,
                                      fontFamily: FontConstant.cairo,
                                      color: _currentIndex == 1
                                          ? AppColors.primary
                                          : AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Espacio para el botón flotante
                          const Spacer(),

                          // Icono de detalles
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() => _currentIndex = 2);
                                _pageController.jumpToPage(2);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.tfsel,
                                    colorFilter: ColorFilter.mode(
                                      _currentIndex == 2
                                          ? AppColors.primary
                                          : AppColors.grey,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'التفصيل',
                                    style: getMediumStyle(
                                      fontSize: FontSize.size12,
                                      fontFamily: FontConstant.cairo,
                                      color: _currentIndex == 2
                                          ? AppColors.primary
                                          : AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Icono de perfil
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() => _currentIndex = 3);
                                _pageController.jumpToPage(3);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.profileIconBottom,
                                    colorFilter: ColorFilter.mode(
                                      _currentIndex == 3
                                          ? AppColors.primary
                                          : AppColors.grey,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'حسابي',
                                    style: getMediumStyle(
                                      fontSize: FontSize.size12,
                                      fontFamily: FontConstant.cairo,
                                      color: _currentIndex == 3
                                          ? AppColors.primary
                                          : AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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
