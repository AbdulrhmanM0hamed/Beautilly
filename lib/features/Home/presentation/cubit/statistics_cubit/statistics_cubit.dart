import 'dart:async';

import 'package:beautilly/features/Home/data/repositories/statistics_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/statistics_repository.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository repository;
  late StreamSubscription _statisticsSubscription;

  StatisticsCubit(this.repository) : super(StatisticsInitial()) {
    // الاستماع للتحديثات
    _statisticsSubscription = (repository as StatisticsRepositoryImpl)
        .statisticsStream
        .listen((_) => getStatistics());
  }

  Future<void> getStatistics() async {
    emit(StatisticsLoading());
    final result = await repository.getStatistics();
    result.fold((failure) => emit(StatisticsError(message: failure.message)),
        (statistics) {
      if (!isClosed) emit(StatisticsLoaded(statistics: statistics));
    });
  }

  @override
  Future<void> close() {
    _statisticsSubscription.cancel();
    (repository as StatisticsRepositoryImpl).dispose();
    return super.close();
  }
}
