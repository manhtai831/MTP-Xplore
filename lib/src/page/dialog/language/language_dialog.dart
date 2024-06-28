import 'package:device_explorer/src/common/manager/setting/setting_manager.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/translate/lang_code.dart';
import 'package:device_explorer/src/common/translate/translate.dart';
import 'package:device_explorer/src/model/sort_model.dart';
import 'package:device_explorer/src/page/dialog/sort/widget/sort_item.dart';
import 'package:flutter/material.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key});

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  List<SortModel> languages = [
    SortModel(id: LangCode.vi, icon: IconPath.vietNam, name: 'Việt Nam'),
    SortModel(id: LangCode.en, icon: IconPath.usa, name: 'English'),
  ];
  SortModel? current;

  @override
  void initState() {
    super.initState();
    current = languages.firstWhere(
      (it) => it.id == (SettingManager().settings.langCode ?? LangCode.en),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...languages.map(_buildItem),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(SortModel e) {
    return SortItem(
      sort: e,
      onChange: () => _onChangeLanguage(e),
      current: current,
    );
  }

  Future<void> _onChangeLanguage(SortModel e) async {
    current = e;
    await Translate().switchLang(e.id);
    setState(() {});
  }
}
