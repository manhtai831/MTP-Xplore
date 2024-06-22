extension StringExt on String? {
  String? get ePath {
    return this?.trim().replaceAll(' ', '\\ ');
  }

}
