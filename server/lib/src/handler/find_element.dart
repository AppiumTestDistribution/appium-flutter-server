import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

class FindElementHandler extends RequestHandler {
  FindElementHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    FindElementModel model =
        FindElementModel.fromJson(await request.body.asJson);

    Finder matchedBy = await ElementHelper.locateElement(model);

    //await FlutterDriver.instance.tester.tap(matchedBy);

    FlutterElement flutterElement = await FlutterDriver.instance
        .getSessionOrThrow()!
        .elementsCache
        .add(matchedBy);

    return AppiumResponse(
        getSessionId(request),
        ElementModel.fromElement(
            flutterElement.id, flutterElement.by.evaluate().first.hashCode));
  }
}
