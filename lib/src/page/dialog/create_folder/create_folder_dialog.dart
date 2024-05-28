import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:flutter/material.dart';

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final TextEditingController _controller = TextEditingController();
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
                  label: Text('New folder name'), hintText: 'Eg: create/new/path'),
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
    await FileManager().addFolder(
        rootPath: PathManager().toString(),
        folderPath: _controller.text.trim());
    ToolBarManager().onReload();
    if (mounted) {
      context.pop();
    }
  }
}
