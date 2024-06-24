import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/setting_model.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:flutter/material.dart';

class CreateFolderDialogArgs {
  TabModel? tab;
  CreateFolderDialogArgs({
    this.tab,
  });
}

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final TextEditingController _controller = TextEditingController();

  CreateFolderDialogArgs get args =>
      SettingModel().settings?.arguments as CreateFolderDialogArgs;
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
                label: Text('New folder name'),
                hintText: 'Eg: create/new/path',
              ),
              onSubmitted: (_) => _onUpdate(),
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
    if (args.tab?.directory?.path == null) {
      Application.showSnackBar('Not found path');
      return;
    }
    await args.tab?.repository.addFolder(
      rootPath: args.tab?.directory?.path ?? '',
      folderPath: _controller.text.trim(),
      device: args.tab?.device,
    );
    if (mounted) {
      context.pop(args: true);
    }
  }
}
