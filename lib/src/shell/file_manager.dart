import 'dart:io';

import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/shell/shell_manager.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  FileManager._();

  static final FileManager _singleton = FileManager._();

  factory FileManager() => _singleton;

  Future<BaseResponse<List<FileModel>>?> getFiles({String? path}) async {
    final result = await ShellManager().run2<List<FileModel>>(
      'ls -la ${path ?? ''}',
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
      {required String filePath, String? toPath}) async {
    toPath ??= (await getApplicationSupportDirectory()).path;
    final result = await ShellManager().runWithoutShell<String>(
        'pull "${filePath.trim()}" "$toPath"',
        fromString: (p0) => '$toPath/${filePath.split('/').lastOrNull}');
    return result;
  }

  Future<BaseResponse<String>?> push(
      {required String filePath, String? toPath}) async {
    bool isFile = false;
    try {
      final file = File(filePath);
      isFile = file.existsSync();
    } catch (e) {
      showLog(e);
    }
    final result = await ShellManager().runWithoutShell<String>(
        'push "${isFile ? filePath.trim() : '${filePath.trim()}/.'}" "${toPath?.trim()}"',
        fromString: (p0) => '$toPath/${filePath.split('/').lastOrNull}');
    return result;
  }
}
