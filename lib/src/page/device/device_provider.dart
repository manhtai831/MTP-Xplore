import 'dart:async';

import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/res/audio_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/shell/device_manager.dart';
import 'package:just_audio/just_audio.dart';

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
    final prev = devices;
    devices.clear();
    final mDevices = await DeviceManager().getDevices();
    devices.addAll(mDevices.data ?? []);
    notify();
    if (devices.isNotEmpty) {
      if (isDiff(prev, devices)) {
        final player = AudioPlayer();
        player.setVolume(1);
        await player.setAsset(AudioPath.deviceConnect);
        await player.play();
        // player.dispose();
      }
    }
  }

  bool isDiff(List<DeviceModel> l1, List<DeviceModel> l2) {
    if (l1.length != l2.length) return true;
    for (int i = 0; i < l1.length; i++) {
      final item1 = l1.elementAt(i);
      final item2 = l2.elementAt(i);
      if (item1.id != item2.id) {
        return true;
      }
    }
    return false;
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
