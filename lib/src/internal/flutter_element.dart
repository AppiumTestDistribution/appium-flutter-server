import 'package:flutter_test/flutter_test.dart';

class FlutterElement {
  Finder _by;
  String _id;
  String? _contextId;

  FlutterElement(this._by, this._id);

  FlutterElement.childElement(
    this._by,
    this._id,
    this._contextId,
  );

  Finder get by => _by;
  String get id => _id;
  String? get contextId => _contextId;
}
