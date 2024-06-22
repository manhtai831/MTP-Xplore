import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/clipboard_data_model.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:device_explorer/src/shell/i_file_manager.dart';

class FileSystemRepository implements IFileManager {
  FileSystemRepository._();

  static final FileSystemRepository _singleton = FileSystemRepository._();

  factory FileSystemRepository() => _singleton;

  @override
  Future<BaseResponse<List<FileModel>>> getFiles({
    String? path,
    DeviceModel? device,
  }) async {
    final process = await Process.run(
      'ls',
      [
        '-l',
        if (ToolBarManager().showHiddenFile) '-a',
        '$path',
      ],
      stderrEncoding: utf8,
      stdoutEncoding: utf8,
    );
    return BaseResponse.fromProcess(process, fromString: (p0) {
      return p0
          .split('\n')
          .skip(1)
          .map(
            (it) =>
                FileModel.fromString(it, isFileSystem: true)..isSystem = true,
          )
          .toList();
    });
  }

  String? getHomePath() {
    return Platform.environment['HOME'];
  }

  @override
  Future<void> addFolder(
      {required String folderPath, required String rootPath}) async {
    final splits = folderPath.split('/');
    String path = rootPath;
    for (var it in splits) {
      path += '/$it';
      await Process.run('mkdir', [
        path.trim(),
      ]);
    }
  }

  @override
  Future<BaseResponse<String>?> delete({required String filePath}) async {
    final process = await Process.run('rm', [
      '-rf',
      filePath.trim(),
    ]);
    return BaseResponse.fromProcess(process,
        fromString: (p0) => p0.split('\n').firstOrNull ?? filePath);
  }

  @override
  Future<BaseResponse<String>?> rename(
      {required String filePath, String? toPath}) async {
    final process = await Process.run('mv', [
      filePath.trim(),
      '${toPath?.trim()}',
    ]);
    return BaseResponse.fromProcess(process,
        fromString: (p0) => p0.split('\n').firstOrNull ?? filePath);
  }

  @override
  Future<void> onPaste(
      {required ClipboardDataModel data, required TabModel targetTab}) async {
    final targetDevice = targetTab.device;
    final targetPath = targetTab.directory?.path;
    // from mobile
    if (data.tab?.device?.isSystem == false) {
      // to computer
      if (targetDevice?.isSystem == true) {
        for (var it in data.files) {
          await FileManager().push(
            device: targetDevice,
            filePath: it.path ?? '',
            toPath: targetPath,
          );
        }
      }
      // from computer
    } else {
      // to computer
      if (targetDevice?.isSystem == true) {
        for (var it in data.files) {
         final result =  await Process.run('cp', [
            it.path ?? '',
            targetPath ?? '',
          ]);
           log('${DateTime.now()}  result:${it.path} -> ${targetPath} ${result.stdout}',name: 'VERBOSE');
        }
      }
    }
  }
}
