import 'package:device_explorer/src/page/file/file_provider.dart';
import 'package:flutter/material.dart';

extension FileProviderScrollExt on FileProvider {
  void scrollToIndex(int index) {
    double target = index * 50;
    if (target >= controller.position.maxScrollExtent) {
      target = controller.position.maxScrollExtent;
    }
    controller.animateTo(target,
        duration: const Duration(microseconds: 500), curve: Curves.linear);
  }

  void focusAndScroll(String? fileName) {
    if (fileName == null) return;
    final highlightFileIndex = files.indexWhere((it) => it.name == fileName);
    if (highlightFileIndex == -1) return;
    scrollToIndex(highlightFileIndex);
    for (var it in files) {
      it.isSelected = false;
    }
    files.elementAtOrNull(highlightFileIndex)?.isSelected = true;
  }
}
