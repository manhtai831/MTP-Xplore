import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/model/setting_model.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPopResult});
  final dynamic Function()? onPopResult;
  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: _onBack,
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
    if (PathManager().paths.isEmpty) return;
    if (SettingModel().settings?.name == RoutePath.files) {
      PathManager().remove();
    }
    final result = onPopResult?.call();
    Application.navigatorKey.currentContext?.pop(args: result);
  }
}
