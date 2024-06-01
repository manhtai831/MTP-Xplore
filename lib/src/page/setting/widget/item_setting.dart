import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:flutter/material.dart';

class ItemSetting extends StatelessWidget {
  const ItemSetting({
    super.key,
    this.title,
    this.icon,
    this.onPressed,
  });
  final String? title;
  final String? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration:
            const BoxDecoration(border: Border(bottom: BorderSide(width: .5))),
        child: Row(
          children: [
            Image.asset(
              icon ?? IconPath.setting,
              width: 32,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: BaseText.bold(
                title: title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
