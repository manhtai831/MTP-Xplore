import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/translate/lang_key.dart';
import 'package:device_explorer/src/common/translate/translate_ext.dart';
import 'package:device_explorer/src/common/widgets/buttons_dialog.dart';
import 'package:device_explorer/src/model/route_setting_model.dart';
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
      RouteSettingModel().settings?.arguments as CreateFolderDialogArgs;
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
                label: Text(LangKey.newFolderTitle.tr),
                hintText: 'Eg: create/new/path',
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
