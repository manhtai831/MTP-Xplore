import 'package:device_explorer/src/common/translate/lang_code.dart';
import 'package:device_explorer/src/common/translate/translate_ext.dart';
import 'package:flutter/material.dart';

class Translate {
  Translate._internal();

  static final Translate _translator = Translate._internal();

  factory Translate() => _translator;

  String? currentLang;

  Map<String, dynamic> languages = {};

  void initialize() {
    switchLang(LangCode.en);
  }

  Future<void> switchLang(String languageCode) async {
    currentLang = languageCode;
    languages = languageCode.getLangData();

    WidgetsBinding.instance.performReassemble();
  }
}