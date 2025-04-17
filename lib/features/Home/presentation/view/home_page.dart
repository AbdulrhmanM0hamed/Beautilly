// import 'package:beautilly/core/services/service_locator.dart';
// import 'package:beautilly/features/Home/presentation/cubit/discounts_cubit/discounts_cubit.dart';
// import 'package:beautilly/features/Home/presentation/cubit/premium_shops_cubit/premium_shops_cubit.dart';
// import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';
// import 'package:beautilly/features/Home/presentation/cubit/statistics_cubit/statistics_cubit.dart';
// import 'package:beautilly/features/Home/presentation/view/widgets/home_view_body.dart';
// import 'package:beautilly/features/nearby/presentation/cubit/search_shops_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomePage extends StatelessWidget {
//   static const String routeName = '/home';

//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => sl<ServicesCubit>()..loadServices(),
//         ),
//         BlocProvider(
//           create: (context) => sl<StatisticsCubit>()..getStatistics(),
//         ),
//         BlocProvider(
//           create: (context) => sl<PremiumShopsCubit>()..loadPremiumShops(),
//         ),
//         BlocProvider(
//           create: (context) => sl<DiscountsCubit>()..loadDiscounts(),
//         ),
//         BlocProvider(
//           create: (context) => sl<SearchShopsCubit>(),
//         ),
//       ],
//       child: Scaffold(
//         body: const HomeViewBody(),
//       ),
//     );
//   }
// } 