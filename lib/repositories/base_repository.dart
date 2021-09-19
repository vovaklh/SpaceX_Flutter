import 'package:graphql/client.dart';
import 'package:space_x/api/parsers/json_type_parser.dart';
import 'package:space_x/di/locator.dart';

abstract class BaseRepository {
  final _client = locator.get<GraphQLClient>();

  Future<T> getSingleData<T>(
    String path,
    String query, [
    Map<String, dynamic> variables = const {},
  ]) async {
    final data = _getData(path, query, variables);

    return JsonTypeParser.decode<T>(data);
  }

  Future<List<T>> getIterableData<T>(
    String path,
    String query, [
    Map<String, dynamic> variables = const {},
  ]) async {
    final data = await _getData(path, query, variables);

    return data == null ? [] : JsonTypeParser.decode<T>(data);
  }

  Future<dynamic> _getData(
    String path,
    String query, [
    Map<String, dynamic> variables = const {},
  ]) async {
    final options = QueryOptions(document: gql(query), variables: variables);
    final queryResult = await _client.query(options);
    final exception = queryResult.exception;

    if (exception != null) throw exception;

    final data = queryResult.data?[path];

    return data;
  }
}
