import 'package:shelf_plus/shelf_plus.dart';

class AppiumResponse {
  String sessionId;
  Object value;

  AppiumResponse(this.sessionId, this.value) {
    if (value is Error) {}
  }

  toHttpResponse() {
    return Response(200, body: value);
  }
}
