import 'package:flutter_test/flutter_test.dart';
import 'package:space_x/api/model_converters/launch_converter.dart';
import 'package:space_x/api/models/launch_model.dart';
import 'package:space_x/api/parsers/json_type_parser.dart';
import 'package:space_x/di/locator.dart';
import 'package:space_x/entities/launch_entity.dart';
import 'package:space_x/exceptions/json_not_found_exception.dart';
import 'package:space_x/repositories/launches_repository/launches_repository.dart';

void main() async {
  await initDependencies();
  final _launchesRepository = locator.get<LaunchesRepository>();
  final _launchConverter = locator.get<LaunchConverter>();
  test('Success converted json to LaucnhEntity', () {
    const json = {'mission_name': 'Shuba', 'details': 'Shuba'};
    final LaunchModel convertedLaunch =
        JsonTypeParser.decode<LaunchModel>(json);
    const expectedLaunch = LaunchModel(missionName: 'Shuba', details: 'Shuba');
    expect(convertedLaunch, expectedLaunch);
  });
  test('Failed converting json to LaucnhEntity', () {
    const json = {'name': 'Shuba'};
    expect(
      () => JsonTypeParser.decode<Launch>(json),
      throwsA(isA<JsonFactoryNotFoundException>()),
    );
  });
  test('Success converted json to list of LaucnhEntity', () {
    const json = [
      {'mission_name': 'Shuba', 'details': 'Shuba'}
    ];
    final List<LaunchModel> convertedLaunches =
        JsonTypeParser.decode<LaunchModel>(json);
    const expectedLaunches = [
      LaunchModel(missionName: 'Shuba', details: 'Shuba')
    ];
    expect(convertedLaunches, expectedLaunches);
  });
  test('Success converterd LaunchModel to LaucnhEntity', () async {
    const laucnhModel = LaunchModel(missionName: 'Shuba');
    final convertedModel = _launchConverter.modelToEntity(laucnhModel);
    const expectedEntity = Launch(missionName: 'Shuba');
    expect(convertedModel, expectedEntity);
  });
  test('Success received list of laucnhes from LaunchesRepository', () async {
    final laucnhes = await _launchesRepository.getLaunches(0);
    expect(laucnhes.isNotEmpty, true);
  });
}
