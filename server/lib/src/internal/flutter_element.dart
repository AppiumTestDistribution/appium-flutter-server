import 'package:appium_flutter_server/src/utils/test_utils.dart';
import 'package:flutter_test/flutter_test.dart';

class FlutterElement {
  final Finder _by;
  final String _id;
  String? _contextId;

  FlutterElement(this._by, this._id);

  FlutterElement.fromBy(Finder by) : this(by, generateUUIDFromFinder(by));

  FlutterElement.childElement(
    this._by,
    this._id,
    this._contextId,
  );

  Finder get by => _by;
  String get id => _id;
  String? get contextId => _contextId;
}
