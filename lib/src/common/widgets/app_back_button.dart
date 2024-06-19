import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onBackPressed});
  final VoidCallback? onBackPressed;
  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onBackPressed ?? _onBack,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          IconPath.back,
          width: 32,
        ),
      ),
    );
  }

  void _onBack() {
    Application.navigatorKey.currentContext?.pop();
  }
}
