import 'dart:async';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

Future<void> main() async {
  // ignore: omit_local_variable_types
  final FlutterDriver driver = await FlutterDriver.connect();
  // ignore: omit_local_variable_types
  final String result =
      await driver.requestData(null, timeout: const Duration(minutes: 1));
  await driver.close();
  exit(result == 'pass' ? 0 : 1);
}
