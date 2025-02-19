part of 'user_statistics_cubit.dart';

abstract class UserStatisticsState {}

class UserStatisticsInitial extends UserStatisticsState {}

class UserStatisticsLoading extends UserStatisticsState {}

class UserStatisticsLoaded extends UserStatisticsState {
  final UserStatistics statistics;
  UserStatisticsLoaded(this.statistics);
}

class UserStatisticsError extends UserStatisticsState {
  final String message;
  UserStatisticsError(this.message);
} 