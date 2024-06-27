import 'package:device_explorer/src/common/translate/lang_code.dart';
import 'package:device_explorer/src/common/translate/res/en.dart';
import 'package:device_explorer/src/common/translate/res/vi.dart';
import 'package:device_explorer/src/common/translate/translate.dart';

extension TranslateExt on String {
  String get tr => translate();

  String translate({List<String>? args}) {
    String? s = Translate().languages[this];
    if (s == null || s.isEmpty) return s = this;
    if (args == null) return s;
    for (var str in args) {
      s = s!.replaceFirst('%s', str);
    }
    return s!;
  }

  Map<String, String> getLangData() {
    switch (this) {
      case LangCode.vi:
        return vi;
      case LangCode.en:
        return en;
      default:
        return en;
    }
  }

  String getLangName() {
    switch (this) {
      case LangCode.vi:
        return 'Tiếng Việt';
      case LangCode.en:
        return 'English';
      default:
        return 'English';
    }
  }
}
