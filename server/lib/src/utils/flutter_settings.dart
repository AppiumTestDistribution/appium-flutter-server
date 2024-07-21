class FlutterSettings {
  Map<String, dynamic> _settings = {};
  static const String flutterElementWaitTimeout = "flutterElementWaitTimeout";

  FlutterSettings() {
    _setDefaultSetting();
  }

  _setDefaultSetting() {
    _settings = {flutterElementWaitTimeout: 5000};
  }

  updateSetting(Map<String, dynamic> capabilities) {
    // if the capability sent by user is present in the settings, then update it.
    // Else the capability is not known to flutter server and ignore
    capabilities.forEach((settingName, value) {
      if (_settings[settingName] != null) {
        _settings[settingName] = value;
      }
    });
  }

  dynamic getSetting(String settingName) {
    return _settings[settingName];
  }

  // Called at the end of session
  reset() {
    _setDefaultSetting();
  }
}
