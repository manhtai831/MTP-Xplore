import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/translate/lang_key.dart';
import 'package:device_explorer/src/common/translate/translate_ext.dart';
import 'package:device_explorer/src/common/widgets/app_back_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/page/dialog/language/language_dialog.dart';
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
              ItemSetting(
                onPressed: () => showDialog(
                  builder: (context) => const LanguageDialog(),
                  context: context,
                ),
                icon: IconPath.language,
                title: LangKey.languageSetting.tr,
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
