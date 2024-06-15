import 'dart:convert';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

class ScreenshotHandler extends RequestHandler {
  ScreenshotHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    try {
      log("Inside handler");
      var binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      var tester = FlutterDriver.instance.tester;
      await binding.convertFlutterSurfaceToImage();
      log("Converted to surface");
      await tester.pumpAndSettle();
      var data = await binding.takeScreenshot("screenshot");
      return AppiumResponse("NO_ID", base64Encode(data));
    } catch (e) {
      return AppiumResponse("NO_ID", e.toString());
    }
  }
}
