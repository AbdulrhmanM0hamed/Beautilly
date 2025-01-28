import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
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
    context.read<ReservationsCubit>().loadMyReservations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationsCubit, ReservationsState>(
      builder: (context, state) {
        if (state is ReservationsLoading) {
          return const Center(child: CustomProgressIndcator());
        }

        if (state is ReservationsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    color: Colors.grey.shade600,
                    fontSize: FontSize.size16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ReservationsCubit>().loadMyReservations();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is ReservationsSuccess) {
          final reservations = state.reservations.where((reservation) {
            final isCompleted = reservation.status == 'completed';
            return widget.isActive ? !isCompleted : isCompleted;
          }).toList();

          if (reservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.isActive 
                      ? 'لا توجد حجوزات نشطة حالياً'
                      : 'لا توجد حجوزات سابقة',
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      color: Colors.grey.shade600,
                      fontSize: FontSize.size16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isActive 
                      ? 'يمكنك حجز موعد جديد من صفحة الأقرب'
                      : 'ستظهر هنا الحجوزات المكتملة',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: Colors.grey.shade500,
                      fontSize: FontSize.size14,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ReservationsCubit>().loadMyReservations();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return ReservationCard(
                  reservation: reservations[index],
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
} 