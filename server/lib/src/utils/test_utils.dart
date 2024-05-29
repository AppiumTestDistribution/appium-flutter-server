bool enumContains<T extends Enum>(List<T> _enum, dynamic value) {
  return _enum.map((e) => e.name).contains(value);
}
