import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/statistics_repository.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository repository;

  StatisticsCubit(this.repository) : super(StatisticsInitial());

  Future<void> getStatistics() async {
    emit(StatisticsLoading());

    final result = await repository.getStatistics();

    result.fold(
      (failure) => emit(StatisticsError(message: failure.message)),
      (statistics) => emit(StatisticsLoaded(statistics: statistics)),
    );
  }
}
