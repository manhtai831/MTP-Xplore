import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';

class FileSettingProvider extends BaseProvider {
  @override
  Future<void> init() async {}

  void onChange(int i, bool v) {
    if (i == 1) {
      ToolBarManager().setShowHiddenFile(v);
    
    }
  }
}
