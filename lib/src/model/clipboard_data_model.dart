import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/model/tab_model.dart';

class ClipboardDataModel {
  List<FileModel> files = [];
  TabModel? tab;
  ClipboardDataModel({
    required this.files,
    this.tab,
  });

  @override
  String toString() => 'ClipboardDataModel(files: $files, tab: $tab)';
}
