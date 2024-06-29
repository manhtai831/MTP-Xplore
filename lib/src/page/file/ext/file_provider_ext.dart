import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/manager/clipboard/clipboard_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/model/clipboard_data_model.dart';
import 'package:device_explorer/src/page/dialog/confirm/confirm_dialog.dart';
import 'package:device_explorer/src/page/dialog/create_folder/create_folder_dialog.dart';
import 'package:device_explorer/src/page/dialog/file_editor/file_editor_dialog.dart';
import 'package:device_explorer/src/page/file/ext/file_provider_scroll_ext.dart';
import 'package:device_explorer/src/page/file/file_provider.dart';
import 'package:flutter/material.dart';

extension FileProviderExt on FileProvider {
  void sortFiles() {
    final sort = ToolBarManager().sort;
    if (sort.isByType) {
      files.sort((a, b) =>
          (a.ext?.toLowerCase() ?? '').compareTo(b.ext?.toLowerCase() ?? ''));
    } else if (sort.isNameAToZ) {
      files.sort((a, b) =>
          (a.name?.toLowerCase() ?? '').compareTo(b.name?.toLowerCase() ?? ''));
    } else if (sort.isNameZToA) {
      files.sort((a, b) =>
          (b.name?.toLowerCase() ?? '').compareTo(a.name?.toLowerCase() ?? ''));
    } else if (sort.isDateAToZ) {
      files.sort((a, b) =>
          (a.created ?? DateTime.now()).compareTo(b.created ?? DateTime.now()));
    } else if (sort.isDateZToA) {
      files.sort((a, b) =>
          (b.created ?? DateTime.now()).compareTo(a.created ?? DateTime.now()));
    } else if (sort.isByLengthIncrement) {
      files.sort((a, b) => (a.size ?? 0).compareTo(b.size ?? 0));
    } else if (sort.isByLengthDecrement) {
      files.sort((a, b) => (b.size ?? 0).compareTo(a.size ?? 0));
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
    if (filePicked.isEmpty) return;
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

}
