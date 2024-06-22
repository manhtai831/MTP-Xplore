import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/widgets/app_header.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/file/file_provider.dart';
import 'package:device_explorer/src/page/file/widget/file_header.dart';
import 'package:device_explorer/src/page/file/widget/file_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilePageArgs {
  FileModel? file;
  FilePageArgs({
    this.file,
  });
}

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends BaseState<FilePage, FileProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        body: KeyboardListener(
          focusNode: provider.focusNode,
          onKeyEvent: provider.onKeyEvent,
          autofocus: true,
          child: Column(
            children: [
              const AppHeader(),
              
              const FileHeader(),
              Expanded(
                child: Consumer<FileProvider>(
                  builder: (_, p, v) => ListView.builder(
                    itemBuilder: _itemBuilder,
                    itemCount: provider.files.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    final file = provider.files.elementAt(index);
    return FileItem(
      file: file,
      onPressed: () => provider.onPressed(file, index),
      onDoubleTap: () => provider.onDoublePressed(file, index),
    );
  }

  @override
  FileProvider get registerProvider => FileProvider();
}
