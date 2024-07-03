import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

bool enumContains<T extends Enum>(List<T> _enum, dynamic value) {
  return _enum.map((e) => e.name).contains(value);
}

String generateUUID() {
  var random = Random.secure();
  var values = List<int>.generate(16, (index) => random.nextInt(256));
  values[6] = (values[6] & 0x0F) | 0x40; // version 4
  values[8] = (values[8] & 0x3F) | 0x80; // variant 2
  var uuid =
      values.map((value) => value.toRadixString(16).padLeft(2, '0')).join('');
  return '${uuid.substring(0, 8)}-${uuid.substring(8, 12)}-${uuid.substring(12, 16)}-${uuid.substring(16, 20)}-${uuid.substring(20, 32)}';
}

String generateUUIDFromFinder(Finder by) {
  try {
    int hashCode = by.evaluate().first.widget.hashCode;
    String hexString = hashCode.toRadixString(16);

    while (hexString.length < 32) {
      hexString += hashCode.toRadixString(16);
    }
    hexString = hexString.substring(0, 32);

    String uuid = '${hexString.substring(0, 8)}-'
        '${hexString.substring(8, 12)}-'
        '${hexString.substring(12, 16)}-'
        '${hexString.substring(16, 20)}-'
        '${hexString.substring(20, 32)}';

    return uuid;
  } catch (e) {
    return generateUUID();
  }
}
