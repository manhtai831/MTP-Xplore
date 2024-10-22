import 'dart:io';

import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/manager/setting/setting_manager.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/dialog/confirm/confirm_dialog.dart';
import 'package:flutter/material.dart';

class StorageProvider extends BaseProvider {
  FileModel? dirStat;
  String? currentPath;
  List<FileModel> files = [];
  @override
  Future<void> init() async {
    getCurrentSize();
  }

  Future<void> getCurrentSize() async {
    final dir = SettingManager().tmpDir;
    currentPath = dir.path;
    double currentSize = 0;
    List<FileSystemEntity> fileSystem = dir.listSync();
    files = fileSystem.map((it) {
      final stat = it.statSync();
      currentSize = currentSize + stat.size;
      return FileModel(
        name: it.path.split('/').lastOrNull,
        size: stat.size * 1.0,
        created: stat.modified,
      );
    }).toList();
    dirStat = FileModel(size: currentSize);

    notify();
  }

  Future<void> clearStorage() async {
    final result = await showDialog(
        context: context,
        builder: (_) => const ConfirmDialog(
              msg: 'Are you want to clear storage?',
            ));
    if (result != true) return;
    for (var it in files) {
      final file = File('$currentPath/${it.name}');
      if (file.statSync().type == FileSystemEntityType.directory) {
        final dir = Directory('$currentPath/${it.name}');
        if (dir.existsSync()) {
          dir.deleteSync(recursive: true);
          continue;
        }
      }

      file.deleteSync();
    }
    getCurrentSize();
  }
}
