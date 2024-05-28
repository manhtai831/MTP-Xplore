import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BaseButton(
                  onPressed: _onBack,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: BaseText(
                      title: 'Cancel',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                BaseButton(
                  onPressed: () => context.pop(args: true),
                  borderRadius: BorderRadius.circular(8),
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

  void _onBack() {
    context.pop(args: false);
  }
}
