import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/detail/widget/unsupport_item.dart';
import 'package:flutter/material.dart';

class FileJsonItem extends StatefulWidget {
  const FileJsonItem({super.key, this.file});
  final FileModel? file;
  @override
  State<FileJsonItem> createState() => _FileJsonItemState();
}

class _FileJsonItemState extends State<FileJsonItem> {
  List<String>? contents = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final path = await widget.file?.getViewPath();
    if (path == null) return;
    final file = File(path);

    try {
      final raw = file.readAsStringSync();
      String content = '';
      try {
        content = getPrettyJSONString(jsonDecode(raw));
      } catch (e1) {
        content = raw;
      }
      contents = content.split('\n');
    } catch (e) {
      contents = null;
    }
    if (mounted) setState(() {});
  }

  String getPrettyJSONString(jsonObject) {
    var encoder = const JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }

  @override
  Widget build(BuildContext context) {
    if (contents == null) {
      return UnsupportItem(
        item: widget.file,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 8),
      itemBuilder: _buildItem,
      itemCount: contents?.length ?? 0,
    );
  }

  Widget? _buildItem(BuildContext context, int index) {
    final item = contents?.elementAt(index);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 38,
          child: BaseText(
            title: index.toString(),
          ),
        ),
        const SizedBox( width: 8),
        Expanded(
          child: BaseText(
            title: item,
          ),
        ),
      ],
    );
  }
}
