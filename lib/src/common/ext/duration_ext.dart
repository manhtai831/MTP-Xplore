Future<void> delay({int milliseconds = 500}) =>
    Future.delayed(Duration(milliseconds: milliseconds));

extension DurationExt on Duration {
  String toDisplay() {
    return toString().split('.').first;
  }
}
