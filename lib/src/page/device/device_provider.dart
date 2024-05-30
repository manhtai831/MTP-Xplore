import 'dart:async';

import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/shell/device_manager.dart';

class DeviceProvider extends BaseProvider {
  List<DeviceModel> devices = [];
  StreamSubscription<String>? _subscription;
  Timer? _timer;

  @override
  Future<void> init() async {
    _subscription = ToolBarManager().onListenOnReload(getDevices);
    getDevices();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => getDevices());
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
