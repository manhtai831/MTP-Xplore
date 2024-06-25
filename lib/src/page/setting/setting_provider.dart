import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingProvider extends BaseProvider {
  PackageInfo? packageInfo;
  
  @override
  Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
    notify();
  }
}
