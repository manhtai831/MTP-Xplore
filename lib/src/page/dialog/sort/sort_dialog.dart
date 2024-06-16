import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/sort_model.dart';
import 'package:device_explorer/src/page/dialog/sort/widget/sort_item.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class SortDialog extends StatefulWidget {
  const SortDialog({super.key});

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  List<SortModel> sorts = [
    SortModel(id: 1, icon: IconPath.aToZ, name: 'Name A to Z'),
    SortModel(id: 2, icon: IconPath.zToA, name: 'Name Z to A'),
    SortModel(id: 3, icon: IconPath.sort, name: 'By Type'),
    SortModel(id: 4, icon: IconPath.date, name: 'Date increment'),
    SortModel(id: 5, icon: IconPath.date, name: 'Date decrement'),
  ];
  SortModel? current;

  @override
  void initState() {
    super.initState();
    current =
        sorts.firstWhereOrNull((it) => ToolBarManager().sort?.id == it.id);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseText.bold(
              title: 'Sort by',
            ),
            ...sorts.map((it) => SortItem(
                  current: current,
                  sort: it,
                  onChange: () => onChange(it),
                ))
          ],
        ),
      ),
    );
  }

  onChange(SortModel it) {
    current = it;
    setState(() {});
    ToolBarManager().setSort(it);
  }
}
