import 'dart:async';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/appium_test_bindings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appium_flutter_server/src/server.dart';
import 'package:integration_test/integration_test.dart';
import 'package:network_tools/network_tools.dart';
import 'package:path_provider/path_provider.dart';

const MAX_TEST_DURATION_SECS = 24 * 60 * 60;

void initializeTest({required Widget app}) async {
  AppiumTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('appium flutter server', (tester) async {
    /* Initialize network tools */
    // final appDocDirectory = await getApplicationDocumentsDirectory();
    // await configureNetworkTools(appDocDirectory.path, enableDebugging: true);
    FlutterDriver.instance.initialize(tester: tester, app: app);
    await tester.pumpWidget(app);
    FlutterServer.instance.startServer(port: 8888);
    // To block the test from ending

    await Completer<void>().future;
  }, timeout: const Timeout(Duration(seconds: MAX_TEST_DURATION_SECS)));
}
