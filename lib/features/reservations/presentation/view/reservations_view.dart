import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../cubit/reservations_cubit.dart';
import 'widgets/my_reservations_widget.dart';

class ReservationsView extends StatelessWidget {
  const ReservationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ReservationsCubit>()..getMyReservations(),
        ),
        BlocProvider(
          create: (_) => sl<BookingCubit>(),
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'حجوزاتي',
              style: getBoldStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: FontSize.size20,
                fontFamily: FontConstant.cairo,
              ),
            ),
            bottom: TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              labelStyle: getMediumStyle(
                color: AppColors.primary,
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
              ),
              unselectedLabelStyle: getMediumStyle(
                color: Colors.grey,
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
              ),
              tabs: const [
                Tab(text: 'الحجوزات النشطة'),
                Tab(text: 'الحجوزات المكتملة'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MyReservationsWidget(isActive: true),
              MyReservationsWidget(isActive: false),
            ],
          ),
        ),
      ),
    );
  }
}
