import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/api/inject_image.dart';
import 'package:appium_flutter_server/src/models/api/set_text.dart';
import 'package:appium_flutter_server/src/utils/camera_mocking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../logger.dart';
import '../utils/element_helper.dart';

class InjectImage extends RequestHandler {
  InjectImage(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    log('InjectImageHandler');
    InjectImageModal injectedImageModal = InjectImageModal.fromJson(await request.body.asJson);
    String base64Image = injectedImageModal.base64Image.toString();

    String fileName = await saveImageToDevice(base64Image);

    return AppiumResponse(getSessionId(request), fileName);
  }
}
