import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/translate/lang_key.dart';
import 'package:device_explorer/src/common/translate/translate_ext.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/page/dialog/sort/sort_dialog.dart';
import 'package:device_explorer/src/page/file/ext/file_provider_ext.dart';
import 'package:device_explorer/src/page/file/file_provider.dart';
import 'package:device_explorer/src/page/tab/tab_provider.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_back_button.dart' as app_back;

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {



  TabProvider get tabProvider => context.read<TabProvider>();
  WrapperProvider get wrapperProvider => context.read<WrapperProvider>();
  FileProvider get fileProvider => context.read<FileProvider>();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(
            color: Colors.black12,
          ))),
      duration: const Duration(milliseconds: 300),
      child: Row(
        children: [
          app_back.AppBackButton(
            onBackPressed: _onBackPressed,
          ),
          const SizedBox(
            width: 8,
          ),
          Tooltip(
            message: LangKey.home.tr,
            child: BaseButton(
              onPressed: _onGoHome,
              child: Image.asset(
                IconPath.home,
                width: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Consumer<WrapperProvider>(
              builder: (_, __, ___) => BaseButton(
                onPressed: _onCopyDir,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: BaseText(
                    title: tabProvider.tab.directory?.path,
                  ),
                ),
              ),
            ),
          ),
          Tooltip(
            message: LangKey.newFolder.tr,
            child: BaseButton(
              onPressed: fileProvider.onAddFolder,
              child: Image.asset(
                IconPath.addFolder,
                width: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Tooltip(
            message: LangKey.rename.tr,
            child: BaseButton(
              onPressed: fileProvider.onEditFileName,
              child: Image.asset(
                IconPath.editFile,
                width: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Tooltip(
            message: LangKey.delete.tr,
            child: BaseButton(
              onPressed: fileProvider.onDelete,
              child: Image.asset(
                IconPath.deleteFile,
                width: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Tooltip(
            message: LangKey.copy.tr,
            child: BaseButton(
              onPressed: fileProvider.onCopy,
              child: Image.asset(
                IconPath.copy,
                width: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Tooltip(
            message: LangKey.paste.tr,
            child: BaseButton(
              onPressed: fileProvider.onPaste,
              child: Image.asset(
                IconPath.paste,
                width: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Tooltip(
            message: LangKey.sort.tr,
            child: BaseButton(
              onPressed: _onSort,
              child: Image.asset(
                IconPath.sort,
                width: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Tooltip(
            message: LangKey.setting.tr,
            child: BaseButton(
              onPressed: _onSetting,
              child: Image.asset(
                IconPath.setting,
                width: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Tooltip(
            message: LangKey.reload.tr,
            child: BaseButton(
              onPressed: fileProvider.getFiles,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  IconPath.reload,
                  width: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSetting() {
    Application.navigatorKey.currentContext?.push(RoutePath.settings);
  }

  void _onSort() {
    showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const SortDialog(),
    );
  }

  void _onGoHome() {
    wrapperProvider.updateDir(null);
    tabProvider.notify();
  }

  void _onBackPressed() {
    final parent = tabProvider.tab.directory?.parent;
    wrapperProvider.updateDir(parent);
    if (parent == null) return;
    fileProvider.getFiles();
  }

  void _onCopyDir() {
    final data = tabProvider.tab.directory?.path;
    if (data == null) return;
    Clipboard.setData(ClipboardData(text: data));
    Application.showSnackBar('Path Copied.');
  }
}
