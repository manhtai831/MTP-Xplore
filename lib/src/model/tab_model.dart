import 'package:device_explorer/src/common/enum/tab_type.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/model/directory_model.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:device_explorer/src/shell/file_system_repository.dart';
import 'package:device_explorer/src/shell/i_file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabModel {
  GlobalKey? key = GlobalKey();
  DirectoryModel? directory;
  bool isSelected = true;
  DeviceModel? device;

  TabModel({
    this.directory,
    this.isSelected = true,
    this.device,
    this.key,
  }) {
    key ??= GlobalKey();
  }

  IFileManager get repository =>
      device?.isSystem == true ? FileSystemRepository() : FileManager();
}
