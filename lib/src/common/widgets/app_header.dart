import 'dart:async';

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/clipboard/clipboard_manager.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/clipboard_data_model.dart';
import 'package:device_explorer/src/model/setting_model.dart';
import 'package:device_explorer/src/page/dialog/confirm/confirm_dialog.dart';
import 'package:device_explorer/src/page/dialog/create_folder/create_folder_dialog.dart';
import 'package:device_explorer/src/page/dialog/file_editor/file_editor_dialog.dart';
import 'package:device_explorer/src/page/dialog/pull_progress/pull_progress_dialog.dart';
import 'package:device_explorer/src/page/dialog/sort/sort_dialog.dart';
import 'package:device_explorer/src/page/file/file_provider.dart';
import 'package:device_explorer/src/page/tab/tab_provider.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_back_button.dart' as app_back;

final pageHeaderDisplay = [
  RoutePath.files,
];

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  bool isUpload = false;
  bool isDownload = false;
  double height = 50;

  bool get isShow => true;

  GlobalKey containerKey = GlobalKey();

  TabProvider get tabProvider => context.read<TabProvider>();
  WrapperProvider get wrapperProvider => context.read<WrapperProvider>();
  FileProvider get fileProvider => context.read<FileProvider>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: SettingModel().controller.stream,
      builder: (_, __) => AnimatedContainer(
        key: containerKey,
        width: double.infinity,
        height: isShow ? height : 0,
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
            Tooltip(
                message: 'Back',
                child: app_back.AppBackButton(
                  onBackPressed: _onBackPressed,
                )),
            const SizedBox(
              width: 8,
            ),
            Tooltip(
              message: 'Home',
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
                builder: (_, __, ___) => BaseText(
                  title: tabProvider.tab.directory?.path,
                ),
              ),
            ),
            Tooltip(
              message: 'New Folder (⌘ + N)',
              child: BaseButton(
                onPressed: _onAddFolder,
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
              message: 'Edit Name (⌘ + D)',
              child: BaseButton(
                onPressed: _onEditFileName,
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
              message: 'Delete (Backspace)',
              child: BaseButton(
                onPressed: _onDelete,
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
              message: 'Copy',
              child: BaseButton(
                onPressed: _onCopy,
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
              message: 'Paste',
              child: BaseButton(
                onPressed: _onPaste,
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
              message: 'Sort',
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
              message: 'Setting',
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
              message: 'Reload file',
              child: BaseButton(
                onPressed: fileProvider.getFiles,
                child: Image.asset(
                  IconPath.reload,
                  width: 32,
                ),
              ),
            ),
          ],
        ),
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

  Future<void> _onPaste() async {
    final clipboard = ClipboardManager().data;
    if (clipboard == null) return;
    final currentProvider = fileProvider;
    final targetTab = tabProvider.tab;
    await targetTab.repository.onPaste(
      data: clipboard,
      targetTab: targetTab,
    );
    Application.showSnackBar('Pasted');
    currentProvider.getFiles();
  }

  Future<void> _onCopy() async {
    ClipboardManager().setData(ClipboardDataModel(
        files: fileProvider.filePicked, tab: tabProvider.tab));
    Application.showSnackBar('Copied');
  }

  Future<void> _onEditFileName() async {
    if (fileProvider.filePicked.isEmpty) {
      Application.showSnackBar('No such file selected');
      return;
    }
    final result = await showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const FileEditorDialog(),
      routeSettings: RouteSettings(
          arguments: FileEditorDialogArgs(
        file: fileProvider.filePicked.lastOrNull,
        tab: tabProvider.tab,
      )),
    );
    if (result != true) return;
    fileProvider.getFiles();
  }

  void _onGoHome() {
    wrapperProvider.updateDir(null);
    tabProvider.notify();
  }

  Future<void> _onDelete() async {
    if (fileProvider.filePicked.isEmpty) {
      Application.showSnackBar('No such file selected');
      return;
    }

    final result = await showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const ConfirmDialog(
        msg: 'Are you want to delete file/files?',
      ),
    );
    if (result != true) return;
    for (var it in fileProvider.filePicked) {
      if (it.path != null) {
        await tabProvider.tab.repository.delete(filePath: it.path!);
      }
    }

    fileProvider.getFiles();
  }

  Future<void> _onAddFolder() async {
    final result = await showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const CreateFolderDialog(),
      routeSettings: RouteSettings(
        arguments: CreateFolderDialogArgs(
          tab: tabProvider.tab,
        ),
      ),
    );
    if (result != true) return;
    fileProvider.getFiles();
  }

  void _onDownloadDoubleTap() {
    showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const PullProgressDialog(),
    );
  }

  void _onBackPressed() {
    final parent = tabProvider.tab.directory?.parent;
    wrapperProvider.updateDir(parent);
    if (parent == null) return;
    fileProvider.getFiles();
  }
}
