import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:flutter/material.dart';

class DeviceItem extends StatelessWidget {
  const DeviceItem({Key? key, this.device, this.onPressed}) : super(key: key);
  final DeviceModel? device;
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
            Image.asset(IconPath.device),
            BaseText.bold(
              title: device?.model,
            )
          ],
        ),
      ),
    );
  }
}
