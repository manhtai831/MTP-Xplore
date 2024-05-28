import 'dart:async';
import 'dart:io';
import 'dart:convert' show utf8;
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/shell/device_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/shell.dart';

class ShellManager {
  ShellManager._();

  static final ShellManager _singleton = ShellManager._();

  factory ShellManager() => _singleton;

  Shell? _shell;
  Shell get shell => _shell!;

  void init() {
    _shell = Shell();
  }

  Future<BaseResponse<T>> run<T>(
    String script, {
    FromString<T>? fromString,
  }) async {
    StreamController<List<int>> _controller = StreamController.broadcast();
    _controller.stream.listen((data) {
      showLog(utf8.decode(data));
    });
    _shell = Shell(
      stdout: _controller.sink,
      verbose: true,
      commandVerbose: true,
      runInShell: true,
      commentVerbose: true,
      options: ShellOptions(),
    );
    final result = await _shell?.run(script);
    return BaseResponse.fromData([...?result], fromString: fromString);
  }

  Future<BaseResponse<T>> run2<T>(
    String script, {
    FromString<T>? fromString,
  }) async {
    final result = await _shell?.run(
      'adb -s ${DeviceManager().current?.id} shell $script',
    );
    return BaseResponse.fromData(result, fromString: fromString);
  }

  Future<BaseResponse<T>> runWithoutShell<T>(
    String script, {
    FromString<T>? fromString,
  }) async {
    final result = await _shell?.run(
      'adb -s ${DeviceManager().current?.id} $script',
    );
    return BaseResponse.fromData(result, fromString: fromString);
  }
}
