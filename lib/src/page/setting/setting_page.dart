import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/translate/lang_code.dart';
import 'package:device_explorer/src/common/translate/lang_key.dart';
import 'package:device_explorer/src/common/translate/translate.dart';
import 'package:device_explorer/src/common/translate/translate_ext.dart';
import 'package:device_explorer/src/common/widgets/app_back_button.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/page/setting/setting_provider.dart';
import 'package:device_explorer/src/page/setting/widget/item_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends BaseState<SettingPage, SettingProvider> {
  @override
  SettingProvider get registerProvider => SettingProvider();

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
            title: LangKey.setting.tr,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ItemSetting(
                onPressed: () => context.push(RoutePath.storage),
                icon: IconPath.storage,
                title: LangKey.storageSetting.tr,
              ),
              ItemSetting(
                onPressed: () => context.push(RoutePath.fileSetting),
                icon: IconPath.setting,
                title: LangKey.fileSetting.tr,
              ),
              BaseButton(
                onPressed: () {
                  final lang = Translate().currentLang == LangCode.vi
                      ? LangCode.en
                      : LangCode.vi;
                  Translate().switchLang(lang);
                },
                child: BaseText(
                  title: 'Change Lang',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Consumer<SettingProvider>(
                builder: (_, __, ___) => BaseText(
                  title:
                      'Version: ${provider.packageInfo?.version} - ${provider.packageInfo?.buildNumber}',
                  fontSize: 12,
                  color: Colors.black26,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
