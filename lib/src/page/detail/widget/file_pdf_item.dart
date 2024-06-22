import 'dart:io';

import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:provider/provider.dart';

class FilePdfItem extends StatefulWidget {
  const FilePdfItem({super.key, this.file});
  final FileModel? file;
  @override
  State<FilePdfItem> createState() => _FilePdfItemState();
}

class _FilePdfItemState extends State<FilePdfItem> {
  String? path;

  WrapperProvider get wrapperProvider => context.read<WrapperProvider>();
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    path = await getPath();
    setState(() {});
  }

  Future<String?> getPath() async {
    String? path = wrapperProvider.isSystem
        ? widget.file?.path
        : '${(await getApplicationSupportDirectory()).path}/${widget.file?.name?.split('/').lastOrNull}';
    if (File(path!).existsSync()) {
      return path;
    }
    final result = await FileManager().pull(filePath: widget.file?.path ?? '');
    if (result.isOke()) {
      path = result.data;
    } else {
      path = result.data?.split(":").firstOrNull;
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return PdfViewer.openFile(
      path!,
      params: const PdfViewerParams(),
    );
  }
}
