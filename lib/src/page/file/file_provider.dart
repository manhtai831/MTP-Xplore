import 'dart:async';
import 'dart:developer';

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/detail/file_detail_page.dart';
import 'package:device_explorer/src/page/dialog/confirm/confirm_dialog.dart';
import 'package:device_explorer/src/page/dialog/create_folder/create_folder_dialog.dart';
import 'package:device_explorer/src/page/dialog/file_editor/file_editor_dialog.dart';
import 'package:device_explorer/src/page/file/file_page.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FileProvider extends BaseProvider {
  List<FileModel> files = [];
  FilePageArgs? args;
  StreamSubscription<String>? _subscription;
  String? path;
  bool? isReload = false;
  final focusNode = FocusNode();
  @override
  Future<void> init() async {
    args = getArguments();
    getFiles();
    _subscription = ToolBarManager().onListenOnReload(() {
      isReload = true;
      getFiles();
    });
  }

  Future<void> getFiles() async {
    path ??= PathManager().toString();
     log('${DateTime.now()}  path: ${path}',name: 'VERBOSE');
    final result = await FileManager().getFiles(path: path);
    log('${DateTime.now()}  result: ${result?.data}', name: 'VERBOSE');
    files = (result?.data ?? [])
        .where((it) =>
            it.name != null && it.name != '?' && it.name!.trim().isNotEmpty)
        .toList();
    final sort = ToolBarManager().sort;
    if (sort != null) {
      if (sort.isByType) {
        files.sort((a, b) => (a.ext ?? '').compareTo(b.ext ?? ''));
      } else if (sort.isNameAToZ) {
        files.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
      } else if (sort.isNameZToA) {
        files.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
      } else if (sort.isDateAToZ) {
        files.sort((a, b) => (a.created ?? DateTime.now())
            .compareTo(b.created ?? DateTime.now()));
      } else if (sort.isDateZToA) {
        files.sort((a, b) => (b.created ?? DateTime.now())
            .compareTo(a.created ?? DateTime.now()));
      }
    }
    // if (isReload != true) {
    //   final realList = files.where((it) => !it.isBack);
    //   if (realList.length == 1) {
    //     final item = realList.elementAt(0);
    //     if (item.isLink) {
    //       onDoublePressed(item, 0);
    //     }
    //   }
    // }

    final backItems = files.where((it) => it.isBack).toList();

    files.removeWhere((it) => it.isBack);
    files.insertAll(0, backItems);
    notify();
    isReload = false;
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
    ToolBarManager().filePicked =
        files.where((it) => it.isSelected == true).toList();
    notify();
    return;
  }

  @override
  void destroy() {
    _subscription?.cancel();
    super.destroy();
  }

  Future<void> onDoublePressed(FileModel file, int index) async {
    ToolBarManager().filePicked.clear();
    for (var it in files) {
      it.isSelected = false;
    }
    notify();
    if (file.isDir || file.isLink) {
      if (file.name == '.') {
        return;
      } else if (file.name == '..') {
        PathManager().remove();
        context.pop();
        return;
      }
    
      PathManager().add(file.getName() ?? '');
      context.push(RoutePath.files, args: FilePageArgs(file: file));
    } else {
      int currentSelected = files.indexOf(file);
      final result = await context.push(
        RoutePath.fileDetail,
        args: FileDetailPageArgs(files: files, initIndex: currentSelected),
      );
      if (result == null) return;

      files.elementAt(result).isSelected = true;
      notify();
    }
    ToolBarManager().filePicked =
        files.where((it) => it.isSelected == true).toList();
  }

  Future<void> onKeyEvent(KeyEvent value) async {
    log('${DateTime.now()}  value: $value', name: 'VERBOSE');
    final isMetaPressed = HardwareKeyboard.instance.isMetaPressed;
    final isAPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyA);
    final isNPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyN);
    final isRPressed =
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyR);
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

    if (isMetaPressed && isAPressed) {
      for (var it in files) {
        it.isSelected = true;
      }
      ToolBarManager().filePicked = files;
      notify();
    } else if (isDeletePressed) {
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
    } else if (isMetaPressed && isNPressed) {
      showDialog(
        context: Application.navigatorKey.currentContext!,
        builder: (context) => const CreateFolderDialog(),
      );
    } else if (isMetaPressed && isRPressed) {
      ToolBarManager().onReload();
    } else if (isMetaPressed && isDPressed) {
      if (ToolBarManager().filePicked.isEmpty) return;
      showDialog(
        context: Application.navigatorKey.currentContext!,
        builder: (context) => const FileEditorDialog(),
      );
    } else if (isEnterPressed) {
      if (ToolBarManager().filePicked.isEmpty) return;
      onDoublePressed(ToolBarManager().filePicked.first,
          files.indexOf(ToolBarManager().filePicked.first));
    } else if (isArrowUpPressed) {
      int index = files.indexOf(files.last);
      if (ToolBarManager().filePicked.isNotEmpty) {
        index = files.indexOf(ToolBarManager().filePicked.first);
        index--;
      }
      if (index < 0) return;
      for (var it in files) {
        it.isSelected = false;
      }
      files.elementAt(index).isSelected = true;
      ToolBarManager().filePicked =
          files.where((it) => it.isSelected == true).toList();
      notify();
    } else if (isArrowDownPressed) {
      int index = files.indexOf(files.first);
      if (ToolBarManager().filePicked.isNotEmpty) {
        index = files.indexOf(ToolBarManager().filePicked.last);
        index++;
      }
      if (index >= files.length) return;
      for (var it in files) {
        it.isSelected = false;
      }
      files.elementAt(index).isSelected = true;
      ToolBarManager().filePicked =
          files.where((it) => it.isSelected == true).toList();
      notify();
    }
  }
}
