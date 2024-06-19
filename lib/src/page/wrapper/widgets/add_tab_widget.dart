import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:flutter/material.dart';

class AddTabWidget extends StatelessWidget {
  const AddTabWidget({super.key, this.onPressed});
final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onPressed,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        child: const Icon(Icons.add)
      ),
    );
  }
}
