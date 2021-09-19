import 'package:space_x/api/model_converters/base_converter.dart';
import 'package:space_x/api/models/launch_model.dart';
import 'package:space_x/entities/launch_entity.dart';

class LaunchConverter implements BaseConverter<LaunchModel, Launch> {
  @override
  Launch modelToEntity(LaunchModel model) {
    return Launch(
      missionName: model.missionName,
      details: model.details,
    );
  }
}
