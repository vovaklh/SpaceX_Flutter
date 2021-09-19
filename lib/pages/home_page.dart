import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:space_x/blocs/home_bloc/home_bloc.dart';
import 'package:space_x/blocs/home_bloc/home_event.dart';
import 'package:space_x/blocs/home_bloc/home_state.dart';
import 'package:space_x/di/locator.dart';
import 'package:space_x/entities/launch_entity.dart';
import 'package:space_x/pages/launch_page.dart';
import 'package:space_x/resources/app_strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _paginatedListKey = PageStorageKey<String>('paginatedList');

  final PagingController<int, Launch> _pagingController =
      PagingController(firstPageKey: 0);
  final _homeBloc = locator.get<HomeBloc>();

  void _initPageListener() {
    _pagingController.addPageRequestListener((pageKey) {
      _homeBloc.add(FetchDataEvent(offset: pageKey));
    });
  }

  void _processError(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _pagingController.error = message;
  }

  void _performSearch(String query) {
    _homeBloc.add(
      SearchEvent(launches: _pagingController.itemList ?? [], query: query),
    );
  }

  void _addNewItems(List<Launch> launches, bool isLastData) {
    final itemLength = _pagingController.nextPageKey ?? 0;
    final next = itemLength + launches.length;
    if (isLastData) {
      _pagingController.appendLastPage(launches);
    } else {
      _pagingController.appendPage(launches, next);
    }
  }

  void _goToLaunchPage(Launch launch) {
    if (launch.missionName != null && launch.details != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LaunchPage(launch: launch)),
      );
    }
  }

  @override
  void initState() {
    _initPageListener();
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _homeBloc,
          child: _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (_, state) {
        if (state is LaunchesLoadedState) {
          _addNewItems(state.launches, state.isLastData);
        } else if (state is LaunchesFailedState) {
          _processError(state.message);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildSearch(context),
              const SizedBox(height: 12),
              Expanded(
                child: state is FilteredLaunchesState
                    ? _buildFilteredList(state.launches)
                    : _buildPaginatedList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearch(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: AppString.search,
      ),
      onChanged: _performSearch,
    );
  }

  Widget _buildPaginatedList() {
    return PagedListView<int, Launch>.separated(
      key: _paginatedListKey,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Launch>(
        itemBuilder: (_, launch, __) {
          return _buildLaunchCard(launch);
        },
      ),
    );
  }

  Widget _buildFilteredList(List<Launch> launches) {
    return ListView.separated(
      itemBuilder: (_, index) => _buildLaunchCard(launches[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: launches.length,
    );
  }

  Widget _buildLaunchCard(Launch launch) {
    return GestureDetector(
      onTap: () => _goToLaunchPage(launch),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            launch.missionName ?? AppString.noDescription,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 4),
          Text(
            launch.details ?? AppString.noDescription,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
