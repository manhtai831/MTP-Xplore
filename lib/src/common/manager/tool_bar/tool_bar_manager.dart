import 'dart:async';

import 'package:device_explorer/src/common/manager/tool_bar/select_mode.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/model/sort_model.dart';
import 'package:flutter/material.dart';

class ToolBarManager {
  ToolBarManager._();

  static final ToolBarManager _singleton = ToolBarManager._();

  factory ToolBarManager() => _singleton;

  final StreamController<String> _controller = StreamController.broadcast();

  SortModel? sort = SortModel(id: 3);
  bool showHiddenFile = false;
  SelectMode selectMode = SelectMode.viewDetail;

  StreamSubscription<String> onListenOnReload(VoidCallback? onReload) {
    return _controller.stream.listen((_) {
      onReload?.call();
    });
  }

  Stream<String> get toolBarStream => _controller.stream;

  void onReload() {
    _controller.add('event');
  }

  void setSort(SortModel? sort) {
    this.sort = sort;
    onReload();
  }

}
