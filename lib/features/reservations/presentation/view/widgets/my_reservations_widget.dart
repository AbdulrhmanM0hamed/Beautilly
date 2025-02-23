import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/responsive/app_responsive.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/reservations_cubit.dart';
import '../../cubit/reservations_state.dart';
import 'reservation_card.dart';


class MyReservationsWidget extends StatefulWidget {
  final bool isActive;

  const MyReservationsWidget({
    super.key,
    required this.isActive,
  });

  @override
  State<MyReservationsWidget> createState() => _MyReservationsWidgetState();
}

class _MyReservationsWidgetState extends State<MyReservationsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ReservationsCubit>().getMyReservations();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= AppResponsive.mobileBreakpoint;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;

    return BlocBuilder<ReservationsCubit, ReservationsState>(
      builder: (context, state) {
        if (state is ReservationsLoading) {
          return const Center(
            child: CustomProgressIndcator(color: AppColors.primary),
          );
        }

        if (state is ReservationsSuccess) {
          final reservations = state.reservations.where((reservation) {
            if (widget.isActive) {
              return reservation.status == 'pending' ||
                  reservation.status == 'confirmed';
            } else {
              return reservation.status == 'completed' ||
                  reservation.status == 'canceled';
            }
          }).toList();

          if (reservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.isActive
                        ? 'لا توجد حجوزات نشطة'
                        : 'لا توجد حجوزات مكتملة',
                    style: getMediumStyle(
                      color: Colors.grey[600]!,
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ReservationsCubit>().getMyReservations();
            },
            child: Builder(
              builder: (context) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: isDesktop ? 24 : 16,
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(size.width),
                    childAspectRatio: _getChildAspectRatio(size.width),
                    crossAxisSpacing: isDesktop ? 24 : 16,
                    mainAxisSpacing: isDesktop ? 24 : 16,
                  ),
                  itemCount: reservations.length,
                  itemBuilder: (context, index) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<ReservationsCubit>(),
                      ),
                      BlocProvider.value(
                        value: context.read<BookingCubit>(),
                      ),
                    ],
                    child: ReservationCard(
                      reservation: reservations[index],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ReservationsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: getMediumStyle(
                    color: Colors.red[600]!,
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ReservationsCubit>().getMyReservations();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 3; // Desktop
    if (width >= 800) return 2; // Tablet
    return 2; // Mobile
  }

  double _getChildAspectRatio(double width) {
    if (width >= 1000) return 1.15; // Desktop - تقليل الارتفاع
    if (width == 800) return 1.1;
    if (width >= 600) return 1.24;
    if (width < 360) return 0.72;
    // Tablet - تقليل الارتفاع
    return 0.90; // Mobile - زيادة الارتفاع
  }
}
