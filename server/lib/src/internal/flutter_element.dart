import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

class FlutterElement {
  final Finder _by;
  final String _id;
  String? _contextId;

  FlutterElement(this._by, this._id);

  FlutterElement.fromBy({required Finder by}) : this(by, Uuid().v4());

  FlutterElement.childElement(
    this._by,
    this._id,
    this._contextId,
  );

  Finder get by => _by;
  String get id => _id;
  String? get contextId => _contextId;
}
