import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:convert' show utf8;

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/ext/string_ext.dart';
import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/model/progress_model.dart';
import 'package:device_explorer/src/shell/device_manager.dart';
import 'package:device_explorer/src/shell/shell_manager.dart';
import 'package:path_provider/path_provider.dart';

typedef FutureCallBack = Future<BaseResponse<String>> Function();

class FileManager {
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

  Future<BaseResponse<List<FileModel>>?> getFiles({String? path}) async {
    final process = await Process.run(
      adb,
      [
        '-s',
        '${DeviceManager().current?.id}',
        'shell',
        'ls',
        '-la',
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
  }) async {
    Completer<BaseResponse<String>> completer = Completer();
    toPath ??= (await getApplicationSupportDirectory()).path;
    final process = await Process.start(adb, [
      '-s',
      '${DeviceManager().current?.id}',
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
      {required String filePath, String? toPath}) async {
    bool isFile = false;
    try {
      final file = File(filePath.ePath ?? '');
      isFile = file.existsSync();
    } catch (e) {
      showLog(e);
    }
    final process = await Process.run(adb, [
      '-s',
      '${DeviceManager().current?.id}',
      'push',
      isFile ? filePath.trim() : '${filePath.trim()}/.',
      '${toPath?.trim()}',
    ]);

    return BaseResponse.fromProcess(process);
  }

  Future<BaseResponse<String>?> rename(
      {required String filePath, String? toPath}) async {
    final process = await Process.run(adb, [
      '-s',
      '${DeviceManager().current?.id}',
      'shell',
      'mv',
      filePath.trim(),
      '${toPath?.trim()}',
    ]);
    return BaseResponse.fromProcess(process,
        fromString: (p0) => p0.split('\n').firstOrNull ?? filePath);
  }

  Future<BaseResponse<String>?> delete({required String filePath}) async {
    final process = await Process.run(adb, [
      '-s',
      '${DeviceManager().current?.id}',
      'shell',
      'rm',
      '-rf',
      filePath.trim(),
    ]);
    return BaseResponse.fromProcess(process,
        fromString: (p0) => p0.split('\n').firstOrNull ?? filePath);
  }

  Future<void> addFolder(
      {required String folderPath, required String rootPath}) async {
    final splits = folderPath.split('/');
    String path = rootPath;
    for (var it in splits) {
      path += '/$it';
      await Process.run(adb, [
        '-s',
        '${DeviceManager().current?.id}',
        'shell',
        'mkdir',
        path.trim(),
      ]);
    }
  }
}
