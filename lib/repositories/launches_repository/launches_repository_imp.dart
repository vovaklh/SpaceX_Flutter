import 'package:space_x/api/model_converters/launch_converter.dart';
import 'package:space_x/api/models/launch_model.dart';
import 'package:space_x/di/locator.dart';
import 'package:space_x/entities/launch_entity.dart';
import 'package:space_x/repositories/launches_repository/launches_repository.dart';

class LaunchesRepositoryImp extends LaunchesRepository {
  final _launchConverter = locator.get<LaunchConverter>();

  @override
  Future<List<Launch>> getLaunches(int offset, [int limit = 10]) async {
    try {
      const query = r'''
      query ($limit: Int!, $offset: Int!) {
        launches(limit: $limit, offset: $offset) {
          mission_name
          details
        }
      }
    ''';
      final variables = {'limit': limit, 'offset': offset};
      final launches =
          await getIterableData<LaunchModel>('launches', query, variables);

      return launches
          .map((launch) => _launchConverter.modelToEntity(launch))
          .toList();
    } catch (exception) {
      rethrow;
    }
  }
}
