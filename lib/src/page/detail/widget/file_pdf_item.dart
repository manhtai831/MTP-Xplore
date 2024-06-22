import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:flutter/material.dart';
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
    path = await widget.file?.getViewPath();
    setState(() {});
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
