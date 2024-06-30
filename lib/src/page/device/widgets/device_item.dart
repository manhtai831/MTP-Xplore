import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:flutter/material.dart';

class DeviceItem extends StatelessWidget {
  const DeviceItem({super.key, this.device, this.onPressed, this.icon});
  final DeviceModel? device;
  final String? icon;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon ??
                  (device?.isSystem == true ? IconPath.disk : IconPath.device),
              width: 48,
            ),
            BaseText.bold(
              title: device?.model,
            )
          ],
        ),
      ),
    );
  }
}
