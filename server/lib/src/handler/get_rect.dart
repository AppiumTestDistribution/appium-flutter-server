
import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

/*
 * TODO: Partially implemented
 * Reference: https://github.com/appium/appium-uiautomator2-server/blob/master/app/src/main/java/io/appium/uiautomator2/core/AxNodeInfoHelper.java#L217
 */
class GetRectHandler extends RequestHandler {
  GetRectHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    var sessionId = getSessionId(request);
    var elementId = getElementId(request);
    FlutterElement element = await FlutterDriver.instance
        .getSessionOrThrow()!
        .elementsCache
        .get(elementId);

    Rect rect = ElementHelper.getElementBounds(element.by);
    return AppiumResponse(sessionId, {
      "x": rect.left.toStringAsFixed(0),
      "y": rect.top.toStringAsFixed(0),
      "height": rect.height.toStringAsFixed(0),
      "width": rect.width.toStringAsFixed(0)
    });
  }
}
