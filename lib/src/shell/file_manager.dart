import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:convert' show utf8;

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/clipboard_data_model.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/model/progress_model.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:device_explorer/src/shell/i_file_manager.dart';
import 'package:device_explorer/src/shell/shell_manager.dart';
import 'package:path_provider/path_provider.dart';

typedef FutureCallBack = Future<BaseResponse<String>> Function();

class FileManager implements IFileManager {
  FileManager._();

  static final FileManager _singleton = FileManager._();

  factory FileManager() => _singleton;

  final pullQueue = Queue<FutureCallBack>();
  final pushQueue = Queue<FutureCallBack>();
  final StreamController<dynamic> pullController = StreamController.broadcast();

  Future<void> addPushQueue(FutureCallBack? onExecute) async {
    bool isQueueExist = pullQueue.isNotEmpty;
    if (isQueueExist) return;
    if (onExecute == null) return;
    pullQueue.add(onExecute);
    while (pushQueue.isNotEmpty) {
      final result = await pushQueue.first.call();
      Application.showSnackBar(result.data);
      pushQueue.removeFirst();
    }
  }

  Future<void> addPullQueue(List<FutureCallBack>? onExecute) async {
    bool isQueueExist = pullQueue.isNotEmpty;
    log('${DateTime.now()}  isQueueExist: $isQueueExist', name: 'VERBOSE');
    if (onExecute == null) return;
    pullQueue.addAll(onExecute);
    if (isQueueExist) return;
    while (pullQueue.isNotEmpty) {
      final result = await pullQueue.removeFirst().call();
      pullController.add(result);
      Application.showSnackBar(result.data);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  Future<BaseResponse<List<FileModel>>?> getFiles(
      {String? path, DeviceModel? device}) async {
    final process = await Process.run(
      adb,
      [
        '-s',
        '${device?.id}',
        'shell',
        'ls',
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
            (it) => FileModel.fromString(it),
          )
          .toList();
    });
  }

  Future<BaseResponse<String>> pull({
    required String filePath,
    FileModel? fileInfo,
    String? toPath,
    bool getResultPath = true,
    StreamSink<dynamic>? progress,
    DeviceModel? device,
  }) async {
    Completer<BaseResponse<String>> completer = Completer();
    toPath ??= (await getApplicationSupportDirectory()).path;
    final process = await Process.start(adb, [
      '-s',
      '${device?.id}',
      'pull',
      filePath.trim(),
      toPath,
    ]);
    String? fileName = filePath.split('/').lastOrNull;
    Timer timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final file = File('$toPath/$fileName');
      if (file.existsSync()) {
        int pulled = file.lengthSync();
        log('${DateTime.now()}  $fileName: ${pulled / 1000} KB',
            name: 'VERBOSE');
        progress?.add(ProgressModel(
          total: fileInfo?.size,
          count: pulled * 1.0,
          fromPath: filePath.trim(),
          toPath: toPath,
        ));
      }
    });

    ShellManager.processHandle(process, onStdOut: (it) {
      completer.complete(
        BaseResponse.success(
          it,
          fromString: (p0) => getResultPath ? '$toPath/$fileName' : p0.trim(),
        ),
      );
      timer.cancel();
    }, onStdErr: (it) {
      completer.complete(
        BaseResponse.error(it),
      );
      timer.cancel();
    });
    return completer.future;
  }

  Future<BaseResponse<String>> push(
      {required String filePath, String? toPath, DeviceModel? device}) async {
    final process = await Process.run(adb, [
      '-s',
      '${device?.id}',
      'push',
      filePath.trim(),
      '${toPath?.trim()}/',
    ]);
    log('${DateTime.now()}  process: ${filePath.trim()} -> ${toPath?.trim()} ${process.stdout}',
        name: 'VERBOSE');

    return BaseResponse.fromProcess(process);
  }

  @override
  Future<BaseResponse<String>?> rename({
    required String filePath,
    String? toPath,
    DeviceModel? device,
  }) async {
    final process = await Process.run(adb, [
      '-s',
      '${device?.id}',
      'shell',
      'mv',
      filePath.trim(),
      '${toPath?.trim()}',
    ]);
    return BaseResponse.fromProcess(process,
        fromString: (p0) => p0.split('\n').firstOrNull ?? filePath);
  }

  @override
  Future<BaseResponse<String>?> delete({
    required String filePath,
    DeviceModel? device,
  }) async {
    final process = await Process.run(adb, [
      '-s',
      '${device?.id}',
      'shell',
      'rm',
      '-rf',
      '\'${filePath.trim()}\'',
    ]);
    return BaseResponse.fromProcess(process,
        fromString: (p0) => p0.split('\n').firstOrNull ?? filePath);
  }

  @override
  Future<void> addFolder({
    required String folderPath,
    required String rootPath,
    DeviceModel? device,
  }) async {
    final splits = folderPath.split('/');
    String path = rootPath;
    for (var it in splits) {
      path += '/$it';
      await Process.run(adb, [
        '-s',
        '${device?.id}',
        'shell',
        'mkdir',
        '\'${path.trim()}\'',
      ]);
    }
  }

  @override
  Future<void> onPaste({
    required ClipboardDataModel data,
    required TabModel targetTab,
  }) async {
    final targetDevice = targetTab.device;
    final targetPath = targetTab.directory?.path;
    // from computer
    if (data.tab?.device?.isSystem == true) {
      // to mobile
      if (targetDevice?.isSystem == false) {
        for (var it in data.files) {
          await push(
            device: targetDevice,
            filePath: '${it.path}',
            toPath: '$targetPath',
          );
        }
      }
    }
  }

  
}
