import 'dart:async';

import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/appium_response.dart';
import 'package:shelf/shelf.dart';

enum HttpMethod { GET, POST, DELETE, PUT, PATCH }

abstract class RequestHandler {
  final String route;

  RequestHandler(this.route);

  Function getHandler() {
    return (Request request) async {
      log('New Request [${request.method}] ${request.requestedUri.toString()}');
      try {
        AppiumResponse response = await handle(request);
        log('response ${response.value}');
        return response.toHttpResponse();
      } catch (e) {
        log(e);
      }
    };
  }

  FutureOr<AppiumResponse> handle(Request request);
}
