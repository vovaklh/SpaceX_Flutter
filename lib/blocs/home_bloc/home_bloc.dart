import 'package:space_x/blocs/base_bloc.dart';
import 'package:space_x/blocs/home_bloc/home_event.dart';
import 'package:space_x/blocs/home_bloc/home_state.dart';
import 'package:space_x/di/locator.dart';
import 'package:space_x/repositories/launches_repository/launches_repository.dart';
import 'package:space_x/utils/error_utils.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  final _launchesRepository = locator.get<LaunchesRepository>();

  HomeBloc() : super(DefaultState());

  @override
  Stream<HomeState> handleError(Object exception) async* {
    yield LaunchesFailedState(message: ErrorUtils.getErrorMessage(exception));
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is FetchDataEvent) {
      yield* _loadLaunches(event);
    } else if (event is SearchEvent) {
      yield* _filterLaunches(event);
    }
  }

  Stream<HomeState> _loadLaunches(FetchDataEvent event) async* {
    try {
      final launches = await _launchesRepository.getLaunches(event.offset);

      yield LaunchesLoadedState(launches: launches);
    } catch (exception) {
      yield* handleError(exception);
    }
  }

  Stream<HomeState> _filterLaunches(SearchEvent event) async* {
    final query = event.query.toLowerCase();
    final minQueryLength = event.minQueryLength;

    if (query.length > minQueryLength) {
      final filteredLaunches = event.launches
          .where((launch) =>
              launch.missionName?.toLowerCase().contains(query) ?? false)
          .toList();

      yield FilteredLaunchesState(launches: filteredLaunches);
    } else {
      yield DefaultState();
    }
  }
}
