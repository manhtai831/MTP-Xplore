import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/widgets/app_back_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/page/setting/widget/item_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends BaseState<SettingPage, BaseProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton(
            onBackPressed: context.pop,
          ),
          title: BaseText.bold(
            title: 'Settings',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ItemSetting(
                onPressed: () => context.push(RoutePath.storage),
                icon: IconPath.storage,
                title: 'Storage',
              ),
              ItemSetting(
                onPressed: () => context.push(RoutePath.storage),
                icon: IconPath.storage,
                title: 'File Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  BaseProvider get registerProvider => BaseProvider();
}
