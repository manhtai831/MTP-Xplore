import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/clipboard_data_model.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/model/tab_model.dart';

abstract class IFileManager {
  Future<BaseResponse<List<FileModel>>?> getFiles({
    String? path,
    DeviceModel? device,
  });

  Future<BaseResponse<String>?> rename({
    required String filePath,
    String? toPath,
  });

  Future<BaseResponse<String>?> delete({
    required String filePath,
  });

  Future<void> addFolder({
    required String folderPath,
    required String rootPath,
  });

  Future<void> onPaste({
    required ClipboardDataModel data,
    required TabModel targetTab,
  });
}
