import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/shell/device_manager.dart';
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
    final result = await _shell?.run(script);
    return BaseResponse.fromData(result, fromString: fromString);
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
