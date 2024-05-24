import 'package:appium_flutter_server/src/exceptions/invalid_argument_exception.dart';
import 'package:appium_flutter_server/src/logger.dart';

final String JWP_ELEMENT_ID_KEY_NAME = "ELEMENT";
final String W3C_ELEMENT_ID_KEY_NAME = "element-6066-11e4-a52e-4f735466cecf";

class W3CCapsUtils {
  static const String FIRST_MATCH_KEY = "firstMatch";
  static const String ALWAYS_MATCH_KEY = "alwaysMatch";

  static final List<String> STANDARD_CAPS = [
    "browserName",
    "browserVersion",
    "platformName",
    "acceptInsecureCerts",
    "pageLoadStrategy",
    "proxy",
    "setWindowRect",
    "timeouts",
    "unhandledPromptBehavior"
  ];
  static const String APPIUM_PREFIX = "appium";

  static bool isStandardCap(String capName) {
    return STANDARD_CAPS.any((cap) => cap.toLowerCase() == capName);
  }

  static Map<String, dynamic> mergeCaps(
      Map<String, dynamic> primary, Map<String, dynamic> secondary) {
    final result = Map<String, dynamic>.from(primary);
    for (final entry in secondary.entries) {
      if (result.containsKey(entry.key)) {
        throw InvalidArgumentException(
            "Property '${entry.key}' should not exist on both primary ($primary) and secondary ($secondary) objects");
      }
      result[entry.key] = entry.value;
    }
    return result;
  }

  static Map<String, dynamic> stripPrefixes(Map<String, dynamic> caps) {
    const prefix = "$APPIUM_PREFIX:";
    final filteredCaps = <String, dynamic>{};
    final badPrefixedCaps = <String>[];
    for (final entry in caps.entries) {
      if (!entry.key.startsWith(prefix)) {
        filteredCaps[entry.key] = entry.value;
        continue;
      }
      final strippedName = entry.key.substring(prefix.length);
      filteredCaps[strippedName] = entry.value;
      if (isStandardCap(strippedName)) {
        badPrefixedCaps.add(strippedName);
      }
    }
    if (badPrefixedCaps.isNotEmpty) {
      throw InvalidArgumentException(
          "The capabilities $badPrefixedCaps are standard capabilities and should not have the '$prefix' prefix");
    }
    return filteredCaps;
  }

  static Map<String, dynamic> parseCapabilities(Map<String, dynamic> caps) {
    final alwaysMatch = caps.containsKey(ALWAYS_MATCH_KEY)
        ? Map<String, dynamic>.from(caps[ALWAYS_MATCH_KEY] as Map)
        : <String, dynamic>{};
    final firstMatch = caps.containsKey(FIRST_MATCH_KEY)
        ? List<Map<String, dynamic>>.from(caps[FIRST_MATCH_KEY] as List)
        : <Map<String, dynamic>>[];

    final allFirstMatchCaps =
        firstMatch.isEmpty ? [<String, dynamic>{}] : firstMatch;
    final requiredCaps = stripPrefixes(alwaysMatch);
    for (final fmc in allFirstMatchCaps) {
      final strippedCaps = stripPrefixes(fmc);
      try {
        return mergeCaps(requiredCaps, strippedCaps);
      } catch (e) {
        log(e);
      }
    }
    throw InvalidArgumentException(
        "Could not find matching capabilities from $caps");
  }
}
