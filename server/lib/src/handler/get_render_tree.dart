import 'dart:io';

import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';

import 'package:shelf_plus/shelf_plus.dart';

class GetRenderTreeByTypeHandler extends RequestHandler {
  GetRenderTreeByTypeHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    final queryParams = request.url.queryParameters;

    final widgetType = queryParams['widgetType'];
    final text = queryParams['text'];
    final key = queryParams['key'];

    try {
      final elements = await ElementHelper.getRenderTreeByType(
        widgetType: widgetType,
        text: text,
        key: key,
      );

      return AppiumResponse(getSessionId(request), elements);
    } catch (e) {
      return AppiumResponse.withError(
        getSessionId(request),
        'Error: ${e.toString()}',
        null,
        HttpStatus.internalServerError,
      );
    }
  }
}
