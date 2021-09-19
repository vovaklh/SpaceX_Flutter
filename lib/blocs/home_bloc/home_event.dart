import 'package:space_x/entities/launch_entity.dart';

abstract class HomeEvent {}

class FetchDataEvent extends HomeEvent {
  final int offset;

  FetchDataEvent({
    required this.offset,
  });
}

class SearchEvent extends HomeEvent {
  final List<Launch> launches;
  final String query;
  final int minQueryLength;

  SearchEvent({
    required this.launches,
    required this.query,
    this.minQueryLength = 3,
  });
}
