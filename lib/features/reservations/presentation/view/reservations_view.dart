import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../cubit/reservations_cubit.dart';
import 'widgets/my_reservations_widget.dart';

class ReservationsView extends StatelessWidget {
  const ReservationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReservationsCubit>(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الحجوزات'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'الحجوزات النشطة'),
                Tab(text: 'الحجوزات السابقة'),
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