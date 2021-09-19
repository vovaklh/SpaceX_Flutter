import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:space_x/api/model_converters/launch_converter.dart';
import 'package:space_x/blocs/home_bloc/home_bloc.dart';
import 'package:space_x/repositories/launches_repository/launches_repository.dart';
import 'package:space_x/repositories/launches_repository/launches_repository_imp.dart';

final GetIt locator = GetIt.instance;

Future<void> initDependencies() async {
  _initGraphqlClient();
  _initRepositories();
  _initModelConverters();
  _initBlocs();
}

void _initGraphqlClient() {
  HttpLink link = HttpLink('https://api.spacex.land/graphql/');

  final client = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
  );

  locator.registerLazySingleton<GraphQLClient>(() => client);
}

void _initRepositories() {
  locator
      .registerLazySingleton<LaunchesRepository>(() => LaunchesRepositoryImp());
}

void _initModelConverters() {
  locator.registerLazySingleton<LaunchConverter>(() => LaunchConverter());
}

void _initBlocs() {
  locator.registerFactory<HomeBloc>(() => HomeBloc());
}
