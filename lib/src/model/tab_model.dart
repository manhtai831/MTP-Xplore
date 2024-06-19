import 'package:device_explorer/src/common/enum/tab_type.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/model/directory_model.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:device_explorer/src/shell/file_system_repository.dart';
import 'package:device_explorer/src/shell/i_file_manager.dart';

class TabModel {
  DirectoryModel? directory;
  bool isSelected = true;
  DeviceModel? device;

  TabModel({
    this.directory,
    this.isSelected = true,
    this.device,
  });

  IFileManager get repository =>
      device?.isSystem == true ? FileSystemRepository() : FileManager();
}
