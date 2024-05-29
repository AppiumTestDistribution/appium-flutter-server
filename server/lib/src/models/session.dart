import 'package:appium_flutter_server/src/internal/element_cache.dart';

class Session {
  static const String NO_ID = "None";

  late String _sessionId;
  late Map<String, dynamic> _capabilities = {};
  final ElementsCache _elementCache = ElementsCache();

  String get sessionId => _sessionId;
  Map<String, dynamic> get capabilities => _capabilities;
  ElementsCache get elementsCache => _elementCache;

  Session(String id, Map<String, dynamic> capabilities) {
    _sessionId = id;
    _updateCapabilities(capabilities);
  }

  void _updateCapabilities(Map<String, dynamic> capabilities) {
    _capabilities = capabilities;
  }
}
