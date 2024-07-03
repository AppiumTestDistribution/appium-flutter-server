K? enumDecodeNullable<K extends Enum, V>(
  Map<K, V> enumValues,
  Object? source, {
  Enum? unknownValue,
}) {
  if (source == null) {
    return null;
  }

  for (var entry in enumValues.entries) {
    if (entry.value == source) {
      return entry.key;
    }
  }

  if (unknownValue == null) {
    throw ArgumentError(
      '`$source` is not one of the supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  if (unknownValue is! K) {
    throw ArgumentError.value(
      unknownValue,
      'unknownValue',
      'Must by of type `$K` or `JsonKey.nullForUndefinedEnumValue`.',
    );
  }

  return unknownValue;
}

K enumDecode<K extends Enum, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  for (var entry in enumValues.entries) {
    if (entry.value == source) {
      return entry.key;
    }
  }

  if (unknownValue == null) {
    throw ArgumentError(
      '`$source` is not one of the supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return unknownValue;
}
