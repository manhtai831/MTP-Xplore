import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/shell/device_manager.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DeviceProvider extends BaseProvider {
  List<DeviceModel> devices = [];
  StreamSubscription<String>? _subscription;
  Timer? _timer;

  @override
  Future<void> init() async {
    _subscription = ToolBarManager().onListenOnReload(getDevices);
    getDevices();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => getDevices());
    // final dir = await getApplicationSupportDirectory();
    // final data = await rootBundle.load('assets/ezyzip.zip');
    // final file = File.fromRawPath(Uint8List.sublistView(data));
    // File('${dir.path}/zipdata.zip').createSync();
    // File('${dir.path}/zipdata.zip').writeAsBytesSync(data.buffer.asUint8List());
    // final inputStream = InputFileStream('assets/platform-tools.zip');
// Decode the zip from the InputFileStream. The archive will have the contents of the
// zip, without having stored the data in memory.
    // final archive = ZipDecoder().decodeBuffer(inputStream);
    // extractArchiveToDisk(archive, dir.path);
  }

  Future<void> getDevices() async {
    devices.clear();
    final mDevices = await DeviceManager().getDevices();
    devices.addAll(mDevices.data ?? []);
    notify();
  }

  void onItemPressed(DeviceModel e) {
    DeviceManager().current = e;
    PathManager().add('/');
    context.push(RoutePath.files);
  }

  @override
  void destroy() {
    _subscription?.cancel();
    _timer?.cancel();
    super.destroy();
  }
}
