import 'dart:convert';
import 'dart:io';

import 'package:appium_flutter_server/src/exceptions/flutter_automation_error.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/api/error.dart';
import 'package:shelf_plus/shelf_plus.dart';

class AppiumResponse {
  String sessionId;
  dynamic value;
  int statusCode;
  StackTrace? stacktrace;

  AppiumResponse(this.sessionId, this.value,
      [this.statusCode = HttpStatus.ok]) {
    value = parseValue(value);
  }

  AppiumResponse.withError(this.sessionId, this.value, this.stacktrace,
      [this.statusCode = HttpStatus.ok]) {
    value = parseValue(value);
  }

  toHttpResponse() {
    log(value);
    return Response(statusCode,
        body: jsonEncode({"sessionId": sessionId, "value": value}),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType});
  }

  Object? parseValue(dynamic value) {
    if (value == null) {
      return value;
    }

    if (value is FlutterAutomationException) {
      statusCode = value.getStatusCode();
      return ErrorModel(
          error: value.getError(),
          message: value.getMessage(),
          stackTrace: stacktrace.toString());
    }

    if (value is Exception || value is Error) {
      var flutterExecption = FlutterAutomationException("");
      statusCode = flutterExecption.getStatusCode();
      return ErrorModel(
          error: flutterExecption.getError(),
          message: value.toString(),
          stackTrace: stacktrace!.toString());
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
