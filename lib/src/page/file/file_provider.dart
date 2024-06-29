import 'dart:async';
import 'dart:io';

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/model/directory_model.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/detail/file_detail_page.dart';
import 'package:device_explorer/src/page/file/ext/file_provider_ext.dart';
import 'package:device_explorer/src/page/file/ext/file_provider_scroll_ext.dart';
import 'package:device_explorer/src/page/file/file_page.dart';
import 'package:device_explorer/src/page/tab/tab_provider.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:provider/provider.dart';

class FileProvider extends BaseProvider {
  List<FileModel> files = [];
  FilePageArgs? args;
  StreamSubscription<String>? _subscription;
  ScrollController controller = ScrollController();

  TabProvider get tabProvider => context.read<TabProvider>();
  
  WrapperProvider get wrapperProvider => context.read<WrapperProvider>();

  List<FileModel> get filePicked =>
      files.where((it) => it.isSelected == true).toList();

  @override
  Future<void> init() async {
    args = getArguments();
    getFiles();
    _subscription = ToolBarManager().onListenOnReload(() {
      getFiles();
    });
  }

  Future<void> getFiles() async {
    final path = tabProvider.tab.directory?.path;
    final result = await tabProvider.tab.repository
        .getFiles(path: path, device: tabProvider.tab.device);

    files = (result?.data ?? [])
        .where((it) =>
            it.name != null && it.name != '?' && it.name!.trim().isNotEmpty)
        .toList();
    for (var it in files) {
      it.joinPath(path!);
    }
    sortFiles();
    final backItems = files.where((it) => it.isBack).toList();

    files.removeWhere((it) => it.isBack);
    files.insertAll(0, backItems);
    notify();
  }

  Future<void> onPressed(FileModel file, int index) async {
    bool isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
    final isMetaPressed = HardwareKeyboard.instance.isMetaPressed;
    if (isShiftPressed) {
      int firstIndex =
          files.indexOf(files.firstWhere((it) => it.isSelected == true));
      if (firstIndex < index) {
        for (int i = firstIndex; i <= index; i++) {
          files[i].isSelected = true;
        }
      } else {
        for (int i = index; i <= firstIndex; i++) {
          files[i].isSelected = true;
        }
      }
    } else if (isMetaPressed) {
      file.isSelected = !file.isSelected;
    } else {
      for (var it in files) {
        it.isSelected = false;
      }
      file.isSelected = !file.isSelected;
    }

    notify();
    return;
  }

  @override
  void destroy() {
    _subscription?.cancel();
    super.destroy();
  }

  Future<void> onDoublePressed(FileModel file, int index) async {
    for (var it in files) {
      it.isSelected = false;
    }
    notify();
    if (file.isDir || file.isLink) {
      if (file.name == '.') {
        return;
      }

      wrapperProvider.updateDir(DirectoryModel(
        parent: tabProvider.tab.directory,
        path: file.path,
      ));
      getFiles();
    } else if (file.isZip) {
      if (wrapperProvider.isSystem) {
        if (wrapperProvider.currentTab.directory?.path == null) return;
        if (file.path == null) return;
        final zipFile = File(file.path!);
        final extractName =
            '${file.getNameWithoutExt()}_${DateTime.now().millisecondsSinceEpoch}';
        Directory destinationDir = Directory(
            '${wrapperProvider.currentTab.directory!.path!}/$extractName');
        try {
          await ZipFile.extractToDirectory(
            zipFile: zipFile,
            destinationDir: destinationDir,
          );
          await getFiles();
          focusAndScroll(extractName);
          Application.showSnackBar('Extracted to: ${destinationDir.path}');
        } catch (e) {
          Application.showSnackBar(e.toString());
        }
      }
    } else {
      int currentSelected = files.indexOf(file);
      tabProvider.tab.focusNode.unfocus();
      final result = await context.push(
        RoutePath.fileDetail,
        args: FileDetailPageArgs(files: files, initIndex: currentSelected),
      );
      tabProvider.tab.focusNode.requestFocus();
      if (result == null) return;

      focusAndScroll(
        files.elementAt(result).name,
      );
      notify();
    }
  }

  Future<void> onKeyEvent(KeyEvent value) async {
    final isMetaPressed = HardwareKeyboard.instance.isMetaPressed;
    final isAPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyA);
    final isNPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyN);
    final isRPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyR);
    final isCPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyC);
    final isVPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyV);
    final isDPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyD);
    final isEnterPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.enter);
    final isArrowUpPressed = HardwareKeyboard.instance
        .isLogicalKeyPressed(LogicalKeyboardKey.arrowUp);
    final isArrowDownPressed = HardwareKeyboard.instance
        .isLogicalKeyPressed(LogicalKeyboardKey.arrowDown);

    final isDeletePressed = HardwareKeyboard.instance
        .isLogicalKeyPressed(LogicalKeyboardKey.backspace);

    // Command + A
    if (isMetaPressed && isAPressed) {
      for (var it in files) {
        it.isSelected = true;
      }
      notify();
      // Delete
    } else if (isDeletePressed) {
      onDelete();
      // Command + N
    } else if (isMetaPressed && isNPressed) {
      onAddFolder();
      // Command + R
    } else if (isMetaPressed && isRPressed) {
      ToolBarManager().onReload();
      // Command + D
    } else if (isMetaPressed && isDPressed) {
      onEditFileName(); // Enter
    } else if (isEnterPressed) {
      if (filePicked.isEmpty) return;
      onDoublePressed(filePicked.first, files.indexOf(filePicked.first));
      // Arrow Up
    } else if (isArrowUpPressed) {
      int index = files.indexOf(files.last);
      if (filePicked.isNotEmpty) {
        index = files.indexOf(filePicked.first);
        index--;
      }
      if (index < 0) return;
      for (var it in files) {
        it.isSelected = false;
      }
      files.elementAt(index).isSelected = true;
      scrollToIndex(index);
      notify();
      // Arrow down
    } else if (isArrowDownPressed) {
      int index = files.indexOf(files.first);
      if (filePicked.isNotEmpty) {
        index = files.indexOf(filePicked.last);
        index++;
      }
      if (index >= files.length) return;
      for (var it in files) {
        it.isSelected = false;
      }
      files.elementAt(index).isSelected = true;
      scrollToIndex(index);
      notify();
    } else if (isMetaPressed && isCPressed) {
      onCopy();
    } else if (isMetaPressed && isVPressed) {
      onPaste();
    }
  }
}
