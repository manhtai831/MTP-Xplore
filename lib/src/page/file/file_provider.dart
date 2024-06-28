import 'dart:async';
import 'dart:io';

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/clipboard/clipboard_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/model/clipboard_data_model.dart';
import 'package:device_explorer/src/model/directory_model.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/detail/file_detail_page.dart';
import 'package:device_explorer/src/page/dialog/confirm/confirm_dialog.dart';
import 'package:device_explorer/src/page/dialog/create_folder/create_folder_dialog.dart';
import 'package:device_explorer/src/page/dialog/file_editor/file_editor_dialog.dart';
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
    final sort = ToolBarManager().sort;
    if (sort.isByType) {
      files.sort((a, b) =>
          (a.ext?.toLowerCase() ?? '').compareTo(b.ext?.toLowerCase() ?? ''));
    } else if (sort.isNameAToZ) {
      files.sort((a, b) => (a.name?.toLowerCase() ?? '')
          .compareTo(b.name?.toLowerCase() ?? ''));
    } else if (sort.isNameZToA) {
      files.sort((a, b) => (b.name?.toLowerCase() ?? '')
          .compareTo(a.name?.toLowerCase() ?? ''));
    } else if (sort.isDateAToZ) {
      files.sort((a, b) => (a.created ?? DateTime.now())
          .compareTo(b.created ?? DateTime.now()));
    } else if (sort.isDateZToA) {
      files.sort((a, b) => (b.created ?? DateTime.now())
          .compareTo(a.created ?? DateTime.now()));
    } else if (sort.isByLengthIncrement) {
      files.sort((a, b) => (a.size ?? 0).compareTo(b.size ?? 0));
    } else if (sort.isByLengthDecrement) {
      files.sort((a, b) => (b.size ?? 0).compareTo(a.size ?? 0));
    }
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
      } else if (file.name == '..') {
        tabProvider.tab.directory = DirectoryModel(
          parent: tabProvider.tab.directory,
          path: file.path,
        );
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

  Future<void> onDelete() async {
    if (filePicked.isEmpty) {
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
    for (var it in filePicked) {
      if (it.path != null) {
        await tabProvider.tab.repository.delete(
          filePath: it.path!,
          device: tabProvider.tab.device,
        );
      }
    }
    Application.showSnackBar('Deleted');
    getFiles();
  }

  Future<void> onAddFolder() async {
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
    getFiles();
  }

  Future<void> onEditFileName() async {
    if (filePicked.isEmpty) return;
    final result = await showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const FileEditorDialog(),
      routeSettings: RouteSettings(
          arguments: FileEditorDialogArgs(
        file: filePicked.lastOrNull,
        tab: tabProvider.tab,
      )),
    );
    if (result != true) return;
    getFiles();
  }

  void onCopy() {
    if(filePicked.isEmpty) return;
    ClipboardManager().setData(
      ClipboardDataModel(
        files: filePicked,
        tab: tabProvider.tab,
      ),
    );
    Application.showSnackBar('Copied');
  }

  Future<void> onPaste() async {
    if (ClipboardManager().data == null) return;
    await tabProvider.tab.repository.onPaste(
      data: ClipboardManager().data!,
      targetTab: tabProvider.tab,
    );
    Application.showSnackBar('Pasted');
    await getFiles();
    final lastFileName = ClipboardManager().data?.files.last.name;
    focusAndScroll(lastFileName);
    notify();
  }

  void scrollToIndex(int index) {
    double target = index * 50;
    if (target >= controller.position.maxScrollExtent) {
      target = controller.position.maxScrollExtent;
    }
    controller.animateTo(target,
        duration: const Duration(microseconds: 500), curve: Curves.linear);
  }

  void focusAndScroll(String? fileName) {
    if (fileName == null) return;
    final highlightFileIndex = files.indexWhere((it) => it.name == fileName);
    if (highlightFileIndex == -1) return;
    scrollToIndex(highlightFileIndex);
    for (var it in files) {
      it.isSelected = false;
    }
    files.elementAtOrNull(highlightFileIndex)?.isSelected = true;
  }
}
