import 'dart:async';

import 'package:device_explorer/src/common/manager/setting/setting_manager.dart';
import 'package:device_explorer/src/model/sort_model.dart';
import 'package:flutter/material.dart';

class ToolBarManager {
  ToolBarManager._();

  static final ToolBarManager _singleton = ToolBarManager._();

  factory ToolBarManager() => _singleton;

  final StreamController<String> _controller = StreamController.broadcast();

  SortModel get sort => SortModel(id: SettingManager().settings.sortId ?? 3);
  
  bool get showHiddenFile => SettingManager().settings.showHiddenFile ?? false;

  StreamSubscription<String> onListenOnReload(VoidCallback? onReload) {
    return _controller.stream.listen((_) {
      onReload?.call();
    });
  }

  Stream<String> get toolBarStream => _controller.stream;

  void onReload() {
    _controller.add('event');
  }

  Future<void> setSort(SortModel? sort) async {
    await SettingManager().updateSetting(
      SettingManager().settings.copyWith(sortId: sort?.id),
    );
    onReload();
  }

  Future<void> setShowHiddenFile(bool value) async {
    await SettingManager().updateSetting(
      SettingManager().settings.copyWith(showHiddenFile: value),
    );
    onReload();
  }
}
