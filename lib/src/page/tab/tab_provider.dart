import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/model/directory_model.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:device_explorer/src/page/tab/tab_page.dart';
import 'package:device_explorer/src/shell/file_system_repository.dart';

class TabProvider extends BaseProvider {
  TabPageArgs? args;
  TabModel get tab => args!.tab!;

  bool get isSystemTab => tab.device?.isSystem == true;
  @override
  Future<void> init() async {
    if (tab.directory == null) {}
  }

  Future<void> setDevice(DeviceModel? device) async {
    if (device == null) return;
    tab.device = device;
    if (device.isSystem) {
      tab.directory = DirectoryModel(path: device.initPath);
    } else {
      tab.directory = DirectoryModel(path: '/');
    }
    notify();
  }
}
