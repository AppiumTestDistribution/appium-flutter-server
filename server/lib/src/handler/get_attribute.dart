import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/stale_element_reference_exception.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

class GetAttributeHandler extends RequestHandler {
  GetAttributeHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    String attribute = getRouteParam(request, "name");
    try {
      FlutterElement element = await FlutterDriver.instance
          .getSessionOrThrow()!
          .elementsCache
          .get(getElementId(request));

      dynamic result = await ElementHelper.getAttribute(element, attribute);

      return AppiumResponse(getSessionId(request), result);
    } catch (e) {
      if (e is StaleElementReferenceException &&
          attribute == NATIVE_ELEMENT_ATTRIBUTES.displayed.name) {
        return AppiumResponse(getSessionId(request), false);
      }
      rethrow;
    }
  }
}
