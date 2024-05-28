import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/ext/string_ext.dart';
import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/shell/shell_manager.dart';
import 'package:path_provider/path_provider.dart';

typedef FutureCallBack = Future<BaseResponse<String>?> Function();

class FileManager {
  FileManager._();

  static final FileManager _singleton = FileManager._();

  factory FileManager() => _singleton;

  final pullQueue = Queue<FutureCallBack>();
  final pushQueue = Queue<FutureCallBack>();
  Timer? _timer;

  Future<void> execute() async {
    while (pullQueue.isNotEmpty) {
      final result = await pullQueue.first.call();
      Application.showSnackBar(result?.data);
      pullQueue.removeFirst();
    }
    while (pushQueue.isNotEmpty) {
      final result = await pushQueue.first.call();

      Application.showSnackBar(result?.data);
      pushQueue.removeFirst();
    }
    _timer?.cancel();
  }

  Future<BaseResponse<List<FileModel>>?> getFiles({String? path}) async {
    final result = await ShellManager().run2<List<FileModel>>(
      'ls -la ${path.ePath ?? ''}',
      fromString: (p0) => p0
          .skip(1)
          .map(
            (it) => FileModel.fromString(it),
          )
          .toList(),
    );
    return result;
  }

  Future<BaseResponse<String>> pull(
      {required String filePath,
      String? toPath,
      bool getResultPath = true}) async {
    toPath ??= (await getApplicationSupportDirectory()).path;
    final result = await ShellManager().runWithoutShell<String>(
        'pull -p "${filePath.trim().ePath}" "$toPath"',
        fromString: (p0) => getResultPath
            ? '$toPath/${filePath.split('/').lastOrNull}'
            : p0.firstOrNull ?? '$toPath/${filePath.split('/').lastOrNull}');
    return result;
  }

  Future<BaseResponse<String>?> push(
      {required String filePath, String? toPath}) async {
    bool isFile = false;
    try {
      final file = File(filePath.ePath ?? '');
      isFile = file.existsSync();
    } catch (e) {
      showLog(e);
    }
    final result = await ShellManager().runWithoutShell<String>(
        'push "${isFile ? filePath.trim().ePath : '${filePath.trim().ePath}/.'}" "${toPath?.trim().ePath}"',
        fromString: (p0) =>
            p0.firstOrNull ?? '$toPath/${filePath.split('/').lastOrNull}');
    return result;
  }

  Future<BaseResponse<String>?> rename(
      {required String filePath, String? toPath}) async {
    final result = await ShellManager().run2<String>(
        'mv "${filePath.trim().ePath}" "${toPath?.trim().ePath}"',
        fromString: (p0) =>
            p0.firstOrNull ?? '$toPath/${filePath.split('/').lastOrNull}');
    return result;
  }

  Future<BaseResponse<String>?> delete({required String filePath}) async {
    final result = await ShellManager().run2<String>(
        'rm -rf "${filePath.trim().ePath}"',
        fromString: (p0) => p0.firstOrNull ?? filePath);
    return result;
  }

  Future<void> addFolder(
      {required String folderPath, required String rootPath}) async {
    final splits = folderPath.split('/');
    String path = rootPath;
    for (var it in splits) {
      path += '/$it';
      await ShellManager().run2<String>('mkdir "${path.ePath}"');
    }
  }
}
