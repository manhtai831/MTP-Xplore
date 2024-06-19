import 'package:device_explorer/src/model/clipboard_data_model.dart';
import 'package:device_explorer/src/model/file_model.dart';

class ClipboardManager {
  ClipboardManager._();

  static final ClipboardManager _singleton = ClipboardManager._();

  factory ClipboardManager() => _singleton;

  ClipboardDataModel? data;

  void setData(ClipboardDataModel data) {
    this.data = data;
  }
}
