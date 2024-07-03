
import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

class GetSizeHandler extends RequestHandler {
  GetSizeHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    var sessionId = getSessionId(request);
    var elementId = getElementId(request);
    FlutterElement element = await FlutterDriver.instance
        .getSessionOrThrow()!
        .elementsCache
        .get(elementId);

    Size size = ElementHelper.getElementSize(element.by);
    return AppiumResponse(sessionId, {
      "height": size.height.toStringAsFixed(0),
      "width": size.width.toStringAsFixed(0)
    });
  }
}
