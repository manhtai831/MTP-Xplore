import 'dart:io';

import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/common/manager/shell/shell_manager.dart';

class DeviceMtpRepository {
  DeviceMtpRepository._();

  static final DeviceMtpRepository _singleton = DeviceMtpRepository._();

  factory DeviceMtpRepository() => _singleton;

  DeviceModel? current;

  Future<BaseResponse<List<DeviceModel>>> getDevices() async {
    final process = await Process.run(adb, [
      'devices',
      '-l',
    ]);
    return BaseResponse.fromProcess(
      process,
      fromString: (t) => t
          .split('\n')
          .skip(1)
          .where((it) => it.isNotEmpty)
          .map((it) => DeviceModel.fromString(it))
          .toList(),
    );
  }
}
