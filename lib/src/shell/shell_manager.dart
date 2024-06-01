import 'dart:convert' show utf8;
import 'dart:developer';
import 'dart:io';

typedef StringCallBack = void Function(String);
String get adb =>
    '${Platform.environment['HOME']}/Library/Android/sdk/platform-tools/adb';

class ShellManager {
  ShellManager._();

  static final ShellManager _singleton = ShellManager._();

  factory ShellManager() => _singleton;
  static processHandle(
    Process process, {
    StringCallBack? onStdOut,
    StringCallBack? onStdErr,
  }) {
    process.stdout.transform(utf8.decoder).listen((it) {
      log('${DateTime.now()}  stdout: ${it}', name: 'VERBOSE');
      onStdOut?.call(it);
    });
    process.stderr.transform(utf8.decoder).listen((it) {
      log('${DateTime.now()}  stderr: ${it}', name: 'VERBOSE');
      onStdErr?.call(it);
    });
  }
}
