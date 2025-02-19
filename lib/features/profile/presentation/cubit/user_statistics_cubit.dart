import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_statistics.dart';
import '../../domain/repositories/user_statistics_repository.dart';

part 'user_statistics_state.dart';

class UserStatisticsCubit extends Cubit<UserStatisticsState> {
  final UserStatisticsRepository repository;

  UserStatisticsCubit({required this.repository}) : super(UserStatisticsInitial());

  Future<void> loadUserStatistics() async {
    emit(UserStatisticsLoading());
    final result = await repository.getUserStatistics();
    result.fold(
      (failure) => emit(UserStatisticsError(failure.message)),
      (statistics) => emit(UserStatisticsLoaded(statistics)),
    );
  }
} 