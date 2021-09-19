import 'package:flutter/material.dart';
import 'package:space_x/di/locator.dart';
import 'package:space_x/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(const MyApp());
}
