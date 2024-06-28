import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/translate/lang_key.dart';
import 'package:device_explorer/src/common/translate/translate_ext.dart';
import 'package:device_explorer/src/common/widgets/buttons_dialog.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/model/route_setting_model.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:flutter/material.dart';

class FileEditorDialogArgs {
  FileModel? file;
  TabModel? tab;
  FileEditorDialogArgs({
    this.file,
    this.tab,
  });
}

class FileEditorDialog extends StatefulWidget {
  const FileEditorDialog({super.key});

  @override
  State<FileEditorDialog> createState() => _FileEditorDialogState();
}

class _FileEditorDialogState extends State<FileEditorDialog> {
  final TextEditingController _controller = TextEditingController();

  FileEditorDialogArgs get args =>
      RouteSettingModel().settings?.arguments as FileEditorDialogArgs;
  @override
  void initState() {
    super.initState();
    final current = args.file;
    final fileName = current?.name;
    if (fileName != null && fileName.isNotEmpty) {
      _controller.text = fileName;
      int lastIndex = fileName.lastIndexOf('.');
      if (lastIndex == -1) {
        lastIndex = fileName.length;
      }
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: lastIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                label: Text(LangKey.newFileName.tr),
              ),
              onSubmitted: (_) => _onUpdate(),
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonsDialog(
              onOke: _onUpdate,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUpdate() async {
    final fromPath = '\'${args.file?.path}\'';
    final toPath = '\'${args.file?.parentPath}/${_controller.text.trim()}\'';
    if (args.file?.path == null) {
      Application.showSnackBar('Path not found');
      return;
    }

    await args.tab?.repository.rename(
      filePath: fromPath,
      toPath: toPath,
      device: args.tab?.device,
    );
    if (mounted) {
      context.pop(args: true);
    }
  }
}
