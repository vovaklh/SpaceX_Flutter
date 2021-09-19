import 'package:equatable/equatable.dart';

class Launch extends Equatable {
  final String? missionName;
  final String? details;

  const Launch({
    required this.missionName,
    this.details,
  });

  @override
  List<Object?> get props => [
        missionName,
        details,
      ];
}
