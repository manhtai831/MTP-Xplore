import 'dart:developer';

import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/ext/duration_ext.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/detail/file_detail_page.dart';
import 'package:flutter/material.dart';

class FileDetailProvider extends BaseProvider {
  FileDetailPageArgs? args;
  late PageController controller;

  @override
  Future<void> init() async {
    args = getArguments();
    controller = PageController(initialPage: args?.initIndex ?? 0);
    controller.addListener(_listen);
  }

  Future<void> onKeyEvent(KeyEvent value) async {
    //     0x00100000302: 'Arrow Left',
    // 0x00100000303: 'Arrow Right',
    if (value.logicalKey.keyLabel == 'Arrow Left') {
      if (controller.page?.toInt() == 0) {
        return;
      }
      await controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
    if (value.logicalKey.keyLabel == 'Arrow Right') {
      if (controller.page?.toInt() == args?.files?.length) {
        return;
      }
      await controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
    if (value.logicalKey.keyLabel == 'Escape') {
      if (mounted) context.pop();
    }
  }

  FileModel? get currentFile {
    return args?.files?.elementAtOrNull(controller.page?.toInt() ?? 0);
  }

  @override
  Future<void> onViewCreated() async {
    notify();
  }

  @override
  void destroy() {
    controller.dispose();
    super.destroy();
  }

  void _listen() {
    notify();
  }
}
