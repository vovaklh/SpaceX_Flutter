import 'package:equatable/equatable.dart';

import 'package:space_x/entities/launch_entity.dart';

abstract class HomeState extends Equatable {}

class DefaultState extends HomeState {
  @override
  List<Object?> get props => [];
}

class LaunchesLoadedState extends HomeState {
  final List<Launch> launches;

  get isLastData => launches.length < 10;

  LaunchesLoadedState({
    required this.launches,
  });

  @override
  List<Object?> get props => [launches];
}

class LaunchesFailedState extends HomeState {
  final String message;
  final DateTime time = DateTime.now();

  LaunchesFailedState({
    required this.message,
  });

  @override
  List<Object?> get props => [message, time];
}

class FilteredLaunchesState extends HomeState {
  final List<Launch> launches;

  FilteredLaunchesState({
    required this.launches,
  });

  @override
  List<Object?> get props => [launches];
}
