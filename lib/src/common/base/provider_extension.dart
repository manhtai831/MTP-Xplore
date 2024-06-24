import 'dart:developer';

import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:flutter/material.dart';

void showLog(dynamic msg) {
  log('${DateTime.now()}    $msg', time: DateTime.now(), name: 'VERBOSE');
}

void showError(dynamic msg) {
  log('${DateTime.now()}  $msg', time: DateTime.now());
}

extension ProviderExtension on BaseProvider {}

extension ContextExt on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  Future<T?> push<T>(String name, {dynamic args, bool replace = false}) {
    if (replace) {
      return navigator.pushReplacementNamed(name, arguments: args);
    }
    return navigator.pushNamed<T>(name, arguments: args);
  }

  void pop({String? util, dynamic args}) {
    if (util != null) {
      return navigator.popUntil(ModalRoute.withName(util));
    }
    navigator.pop(args);
  }
}
