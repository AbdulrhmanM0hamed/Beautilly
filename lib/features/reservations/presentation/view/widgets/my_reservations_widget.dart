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
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ReservationsCubit>().loadMyReservations();
                  },
                  child: const Text('إعادة المحاولة'),
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
              child: Text(
                widget.isActive ? 'لا توجد حجوزات نشطة' : 'لا توجد حجوزات سابقة',
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