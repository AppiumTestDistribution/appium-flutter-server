import 'dart:async';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appium_flutter_server/src/server.dart';
import 'package:integration_test/integration_test.dart';
import 'package:network_tools/network_tools.dart';
import 'package:path_provider/path_provider.dart';

const MAX_TEST_DURATION = 24 * 60 * 60;

Future<WidgetTester> createIntegrationTest() {
  Completer<WidgetTester> completer = Completer<WidgetTester>();

  return completer.future;
}

void initializeTest({required Widget app}) async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  testWidgets('appium flutter server', (tester) async {
    /* Initialize network tools */
    final appDocDirectory = await getApplicationDocumentsDirectory();
    await configureNetworkTools(appDocDirectory.path, enableDebugging: true);
    await FlutterDriver.getInstance().initialize(tester: tester);

    //int freePort = await getFreePort();
    //log("Free port is: $freePort");

    await tester.pumpWidget(app);
    await startServer(tester, port: 8888);

    // To block the test from ending
    await Completer<void>().future;
  }, timeout: const Timeout(Duration(seconds: MAX_TEST_DURATION)));
}
