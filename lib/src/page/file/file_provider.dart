import 'dart:async';

import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/detail/file_detail_page.dart';
import 'package:device_explorer/src/page/file/file_page.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:flutter/services.dart';

class FileProvider extends BaseProvider {
  List<FileModel> files = [];
  FilePageArgs? args;
  StreamSubscription<String>? _subscription;
  String? path;
  bool? isReload = false;
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
    final result = await FileManager().getFiles(path: path);
    files = result?.data ?? [];
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
    if (isReload != true) {
      final realList = files.where((it) => !it.isBack);
      if (realList.length == 1) {
        final item = realList.elementAt(0);
        if (item.isLink) {
          onDoublePressed(item, 0);
        }
      }
    }

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
    if (file.isDir) {
      if (file.name == '.') {
        return;
      } else if (file.name == '..') {
        PathManager().remove();
        context.pop();
        return;
      }
      PathManager().add(file.name ?? '');
      context.push(RoutePath.files, args: FilePageArgs(file: file));
    } else if (file.isLink) {
      PathManager().removeAll();
      PathManager().addMany(file.linkTo ?? '');
      await context.push(RoutePath.files, args: FilePageArgs(file: file));
      PathManager().removeAll();
      PathManager().addMany(path ?? '');
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
  }
}
