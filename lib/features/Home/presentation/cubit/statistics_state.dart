import '../../data/models/statistics_model.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final StatisticsModel statistics;

  StatisticsLoaded({required this.statistics});
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError({required this.message});
}
