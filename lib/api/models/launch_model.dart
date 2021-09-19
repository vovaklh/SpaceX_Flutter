import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'launch_model.g.dart';

@JsonSerializable()
class LaunchModel extends Equatable {
  @JsonKey(name: 'mission_name')
  final String? missionName;
  final String? details;

  const LaunchModel({
    required this.missionName,
    this.details,
  });

  Map<String, dynamic> toJson() => _$LaunchModelToJson(this);

  static const fromJsonFactory = _$LaunchModelFromJson;

  @override
  List<Object?> get props => [missionName, details];
}
