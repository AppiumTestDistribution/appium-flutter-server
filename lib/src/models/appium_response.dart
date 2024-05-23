import 'dart:convert';
import 'dart:io';

import 'package:shelf_plus/shelf_plus.dart';

class AppiumResponse {
  String sessionId;
  dynamic value;
  int statusCode;

  AppiumResponse(this.sessionId, this.value,
      [this.statusCode = HttpStatus.ok]) {
    value = parseValue(value);
  }

  toHttpResponse() {
    return Response(statusCode,
        body: jsonEncode({"sessionId": sessionId, "value": value}),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType});
  }

  Object? parseValue(dynamic value) {
    if (value == null) {
      return value;
    }

    var invokeResult = _invokeToJsonMethod(value);
    if (invokeResult != null) {
      return invokeResult;
    }
    return value;
  }

  Object? _invokeToJsonMethod(dynamic object) {
    try {
      if (object.toJson != null) {
        return object.toJson();
      }
    } on NoSuchMethodError catch (e) {
      if (!e.toString().contains("'toJson'")) {
        rethrow;
      }
    }
    return null;
  }
}
