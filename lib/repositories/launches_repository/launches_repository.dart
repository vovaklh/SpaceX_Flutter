import 'package:space_x/entities/launch_entity.dart';
import 'package:space_x/repositories/base_repository.dart';

abstract class LaunchesRepository extends BaseRepository {
  Future<List<Launch>> getLaunches(int offset, [int limit = 10]);
}
