import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/widgets/app_back_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/page/setting/file/file_setting_provider.dart';
import 'package:device_explorer/src/page/setting/file/widgets/check_setting_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileSettingPage extends StatefulWidget {
  const FileSettingPage({super.key});

  @override
  State<FileSettingPage> createState() => _FileSettingPageState();
}

class _FileSettingPageState
    extends BaseState<FileSettingPage, FileSettingProvider> {
  @override
  FileSettingProvider get registerProvider => FileSettingProvider();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: BaseText.bold(
            title: 'File setting',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CheckSettingItem(
                title: 'Show hidden file',
                defaultCheck: ToolBarManager().showHiddenFile,
                onChange: (v) => provider.onChange(1, v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
