import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

class GetTextHandler extends RequestHandler {
  GetTextHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    FlutterElement element = await FlutterDriver.instance
        .getSessionOrThrow()!
        .elementsCache
        .get(getElementId(request));

    String elementText = await ElementHelper.getText(element);

    return AppiumResponse(getSessionId(request), elementText);
  }
}
