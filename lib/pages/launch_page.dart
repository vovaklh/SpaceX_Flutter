import 'package:flutter/material.dart';
import 'package:space_x/entities/launch_entity.dart';

class LaunchPage extends StatelessWidget {
  final Launch launch;

  const LaunchPage({
    required this.launch,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                launch.missionName ?? '',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 12),
              Text(
                launch.details ?? '',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
