import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/translate/translate_ext.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:flutter/material.dart';

import '../translate/lang_key.dart';
import 'base_text.dart';

class ButtonsDialog extends StatelessWidget {
  const ButtonsDialog({super.key, this.onOke});
  final VoidCallback? onOke;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BaseButton(
          borderRadius: BorderRadius.circular(8),
          onPressed: () => context.pop(args: false),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: Text(LangKey.cancel.tr),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        BaseButton(
          borderRadius: BorderRadius.circular(8),
          onPressed: onOke,
          child: Ink(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 32,
              ),
              child: BaseText(
                title: LangKey.ok.tr,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
