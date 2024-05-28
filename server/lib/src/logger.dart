const LOG_PREFIX = "[APPIUM FLUTTER] ";

void log(Object? message) {
  if (message != null) {
    print('$LOG_PREFIX $message');
  }
}
