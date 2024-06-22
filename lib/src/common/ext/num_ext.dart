extension NumExt on num {
  String addZero({int length = 1}) {
    return List.generate(length, (i) => '0').join('') + toString();
  }
}
