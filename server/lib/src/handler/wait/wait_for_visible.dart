import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/wait/base_wait.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/api/wait.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shelf_plus/shelf_plus.dart';

class WaitForVisibleHandler extends BaseWaithHandler {
  WaitForVisibleHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    FlutterDriver.instance.getSessionOrThrow();
    WaitModel model = WaitModel.fromJson(await request.body.asJson);
    FlutterElement element = await resolveElement(model);

    await ElementHelper.waitForElementVisible(element,
        timeout: model.timeout ?? BaseWaithHandler.defaultWaitTimeout);

    return AppiumResponse(getSessionId(request), null);
  }
}
