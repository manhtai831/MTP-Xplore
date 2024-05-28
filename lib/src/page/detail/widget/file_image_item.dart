import 'dart:io';

import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:flutter/material.dart';

class FileImageItem extends StatefulWidget {
  const FileImageItem({super.key, this.file});
  final FileModel? file;
  @override
  State<FileImageItem> createState() => _FileImageItemState();
}

class _FileImageItemState extends State<FileImageItem> {
  String? path;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final result = await FileManager()
        .pull(filePath: '${PathManager().toString()}/${widget.file?.name}');
    if (result.error == null) {
      path = result.error;
    } else {
      path = result.data?.split(":").firstOrNull;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (path == null) return const Center(child: CircularProgressIndicator());
    if (!File(path ?? '').existsSync()) {
      return BaseText.bold(
        title: path,
        color: Colors.red,
      );
    }
    showLog('file://$path');
    return InteractiveViewer(
        maxScale: 10, minScale: .8, child: Image.file(File(path ?? '')));
  }
}
