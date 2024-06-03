import 'dart:async';

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/setting_model.dart';
import 'package:device_explorer/src/page/dialog/confirm/confirm_dialog.dart';
import 'package:device_explorer/src/page/dialog/create_folder/create_folder_dialog.dart';
import 'package:device_explorer/src/page/dialog/file_editor/file_editor_dialog.dart';
import 'package:device_explorer/src/page/dialog/pull_progress/pull_progress_dialog.dart';
import 'package:device_explorer/src/page/dialog/sort/sort_dialog.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

  bool get isShow => pageHeaderDisplay.contains(SettingModel().settings?.name);

  GlobalKey containerKey = GlobalKey();
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
        ),
        duration: const Duration(milliseconds: 300),
        child: Row(
          children: [
            const app_back.AppBackButton(),
            const SizedBox(
              width: 8,
            ),
            BaseButton(
              onPressed: _onGoHome,
              child: Image.asset(
                IconPath.home,
                width: 32,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: StreamBuilder<String>(
                stream: PathManager().stream,
                builder: (_, snapshot) => BaseText(
                  title: PathManager().toString(),
                ),
              ),
            ),
            BaseButton(
              onPressed: _onAddFolder,
              child: Image.asset(
                IconPath.addFolder,
                width: 32,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            BaseButton(
              onPressed: _onEditFileName,
              child: Image.asset(
                IconPath.editFile,
                width: 32,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            BaseButton(
              onPressed: _onDelete,
              child: Image.asset(
                IconPath.deleteFile,
                width: 32,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            BaseButton(
              onPressed: _onUpload,
              child: Image.asset(
                isUpload ? IconPath.upload : IconPath.staticUpload,
                width: 32,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            BaseButton(
              onDoubleTap: _onDownloadDoubleTap,
              onPressed: _onDownload,
              child: Image.asset(
                isDownload ? IconPath.download : IconPath.staticDownload,
                width: 32,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            BaseButton(
              onPressed: _onSort,
              child: Image.asset(
                IconPath.sort,
                width: 32,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            BaseButton(
              onPressed: _onSetting,
              child: Image.asset(
                IconPath.setting,
                width: 32,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            BaseButton(
              onPressed: ToolBarManager().onReload,
              child: Image.asset(
                IconPath.reload,
                width: 32,
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

  Future<void> _onDownload() async {
    if (ToolBarManager().filePicked.isEmpty) {
      return;
    }
    final downloadDir = await getDownloadsDirectory();
    String? path = await FilesystemPicker.open(
      title: 'Save to folder',
      context: Application.navigatorKey.currentContext!,
      rootDirectory: downloadDir,
      fsType: FilesystemType.folder,
      pickText: 'Save file to this folder',
    );
    if (path == null) return;

    FileManager().addPullQueue(
      ToolBarManager()
          .filePicked
          .map(
            (it) => () => FileManager().pull(
                  filePath: '${PathManager().toString()}/${it.name}',
                  fileInfo: it,
                  progress: FileManager().pullController.sink,
                  toPath: path,
                  getResultPath: false,
                ),
          )
          .toList(),
    );
  }

  Future<void> _onUpload() async {
    final downloadDir = await getDownloadsDirectory();
    String? path = await FilesystemPicker.open(
      title: 'Open file/folder',
      context: Application.navigatorKey.currentContext!,
      rootDirectory: downloadDir,
      fsType: FilesystemType.all,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    if (path == null) return;

    FileManager().addPushQueue(
      () async {
        final result = await FileManager().push(
          filePath: path,
          toPath: PathManager().toString(),
        );
        ToolBarManager().onReload();
        return result;
      },
    );
  }

  void _onEditFileName() {
    if (ToolBarManager().filePicked.isEmpty) return;
    showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const FileEditorDialog(),
    );
  }

  void _onGoHome() {
    PathManager().removeAll();
    Application.navigatorKey.currentContext?.pop(util: RoutePath.devices);
  }

  Future<void> _onDelete() async {
    if (ToolBarManager().filePicked.isEmpty) return;
    final result = await showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const ConfirmDialog(
        msg: 'Are you want to delete file/files?',
      ),
    );
    if (result != true) return;
    final fromPath =
        '${PathManager()}/${ToolBarManager().filePicked.last.name ?? ''}';
    await FileManager().delete(filePath: fromPath);
    ToolBarManager().onReload();
    if (mounted) {
      context.pop();
    }
  }

  void _onAddFolder() {
    showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const CreateFolderDialog(),
    );
  }

  void _onDownloadDoubleTap() {
    showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const PullProgressDialog(),
    );
  }
}
