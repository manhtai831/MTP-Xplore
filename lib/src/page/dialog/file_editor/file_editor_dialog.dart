import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:flutter/material.dart';

class FileEditorDialog extends StatefulWidget {
  const FileEditorDialog({super.key});

  @override
  State<FileEditorDialog> createState() => _FileEditorDialogState();
}

class _FileEditorDialogState extends State<FileEditorDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final current = ToolBarManager().filePicked.last;
    final fileName = current.name;
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
              decoration: const InputDecoration(
                label: Text('New Name'),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BaseButton(
                  borderRadius: BorderRadius.circular(8),
                  onPressed: _onCancel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                BaseButton(
                  borderRadius: BorderRadius.circular(8),
                  onPressed: _onUpdate,
                  child: Ink(
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 32,
                      ),
                      child: BaseText(
                        title: 'OK',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onCancel() {
    context.pop();
  }

  Future<void> _onUpdate() async {
    final fromPath =
        '${PathManager().toString()}/${ToolBarManager().filePicked.last.name ?? ''}';
    final toPath = '${PathManager().toString()}/${_controller.text.trim()}';
    final result =
        await FileManager().rename(filePath: fromPath, toPath: toPath);
    Application.showSnackBar(result?.data);
    ToolBarManager().onReload();
    if (mounted) {
      context.pop();
    }
  }
}
