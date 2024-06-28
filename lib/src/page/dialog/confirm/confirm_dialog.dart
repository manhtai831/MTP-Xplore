import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/common/widgets/buttons_dialog.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({super.key, this.msg});
  final String? msg;
  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            BaseText(title: widget.msg ?? ''),
            const SizedBox(
              height: 16,
            ),
            ButtonsDialog(
              onOke: () => context.pop(args: true),
            ),
          ],
        ),
      ),
    );
  }
}
