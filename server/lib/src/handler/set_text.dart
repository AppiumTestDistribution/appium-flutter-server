import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/api/set_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../logger.dart';
import '../utils/element_helper.dart';

class SetTextHandler extends RequestHandler {
  SetTextHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    log('SetTextHandler');
    SetTextModal setTextModal = SetTextModal.fromJson(await request.body.asJson);
    FlutterElement element = await FlutterDriver.instance
        .getSessionOrThrow()!
        .elementsCache
        .get(getElementId(request));
    log('@@@@@@@@');
    log(setTextModal.text);
    String setText = setTextModal.text != null ? setTextModal.text : '';
    await ElementHelper.setText(element, setTextModal.text);

    return AppiumResponse(getSessionId(request), null);
  }
}
