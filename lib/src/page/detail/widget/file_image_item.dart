import 'dart:io';

import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class FileImageItem extends StatefulWidget {
  const FileImageItem({super.key, this.file});
  final FileModel? file;
  @override
  State<FileImageItem> createState() => _FileImageItemState();
}

class _FileImageItemState extends State<FileImageItem> {
  String? path;

  WrapperProvider get wrapperProvider => context.read<WrapperProvider>();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    path = wrapperProvider.isSystem
        ? widget.file?.path
        : '${(await getApplicationSupportDirectory()).path}/${widget.file?.name?.split('/').lastOrNull}';
    if (File(path!).existsSync()) {
      if (mounted) setState(() {});
      return;
    }
    final result = await FileManager()
        .pull(filePath: widget.file?.path ?? '', fileInfo: widget.file);
    if (!result.isOke()) {
      path = result.raw;
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
        maxScale: 50, minScale: .8, child: Image.file(File(path ?? '')));
  }
}
