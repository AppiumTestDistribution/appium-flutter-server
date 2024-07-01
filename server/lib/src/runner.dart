import 'dart:async';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/appium_test_bindings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appium_flutter_server/src/server.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

const MAX_TEST_DURATION_SECS = 24 * 60 * 60;
const SERVER_VERSION = '0.0.14';

void initializeTest({Widget? app, Function? callback}) async {
  IntegrationTestWidgetsFlutterBinding binding =
      AppiumTestWidgetsFlutterBinding.ensureInitialized();
  if (app == null && callback == null) {
    throw Exception("App and callback cannot be null");
  }

  testWidgets('appium flutter server', (tester) async {
    if (callback != null) {
      await callback(tester);
    } else {
      await tester.pumpWidget(app!);
    }

    var appInfo = await PackageInfo.fromPlatform();
    // Need a better way to fetch this for automated release, this needs to be updated along with version bump
    // Can stay for now as it is not a breaking change
    FlutterDriver.instance.initialize(
        tester: tester,
        binding: binding,
        appInfo: appInfo,
        serverVersion: SERVER_VERSION);

    FlutterServer.instance.startServer();

    // To block the test from ending
    await Completer<void>().future;
  }, timeout: const Timeout(Duration(seconds: MAX_TEST_DURATION_SECS)));
}
