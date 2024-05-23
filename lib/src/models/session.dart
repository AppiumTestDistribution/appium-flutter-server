class Session {
  static const String _NO_ID = "None";

  late String _sessionId;
  late Map<String, Object> _capabilities = {};

  Session(String id, Map<String, Object> capabilities) {
    _sessionId = id;
    _updateCapabilities(capabilities);
  }

  void _updateCapabilities(Map<String, Object> capabilities) {
    _capabilities = capabilities;
  }
}
