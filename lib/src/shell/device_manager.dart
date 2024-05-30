
import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/shell/shell_manager.dart';

class DeviceManager {
  DeviceManager._();

  static final DeviceManager _singleton = DeviceManager._();

  factory DeviceManager() => _singleton;

  DeviceModel? current;

  Future<BaseResponse<List<DeviceModel>>> getDevices() async {
    final result = await ShellManager().run<List<DeviceModel>>(
      '$adb devices -l',
      fromString: (t) => t
          .skip(1)
          .where((it) => it.isNotEmpty)
          .map((it) => DeviceModel.fromString(it))
          .toList(),
    );
    return result;
  }
}
