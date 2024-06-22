import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/sort_model.dart';
import 'package:flutter/material.dart';

class FileHeader extends StatefulWidget {
  const FileHeader({super.key});

  @override
  State<FileHeader> createState() => _FileHeaderState();
}

class _FileHeaderState extends State<FileHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 2,
          offset: Offset(-1, 2),
          color: Colors.black12,
        )
      ]),
      child: Row(
        children: [
          const SizedBox(width: 32),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: BaseButton(
              onPressed: _onFilterName,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: StreamBuilder(
                  stream: ToolBarManager().toolBarStream,
                  builder: (_, __) => BaseText(
                    title: 'Name',
                    fontWeight: ToolBarManager().sort?.isNameAToZ == true ||
                            ToolBarManager().sort?.isNameZToA == true
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          BaseButton(
            onPressed: _onFilterByLength,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              width: 100,
              alignment: Alignment.center,
              child: StreamBuilder<String>(
                  stream: ToolBarManager().toolBarStream,
                  builder: (context, snapshot) {
                    return BaseText(
                      title: 'Length',
                      fontWeight: ToolBarManager().sort?.isByLengthIncrement ==
                                  true ||
                              ToolBarManager().sort?.isByLengthDecrement == true
                          ? FontWeight.bold
                          : FontWeight.normal,
                    );
                  }),
            ),
          ),
          BaseButton(
            onPressed: _onTypePressed,
            child: Container(
              width: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              child: StreamBuilder<String>(
                  stream: ToolBarManager().toolBarStream,
                  builder: (context, snapshot) {
                    return BaseText(
                      title: 'Type',
                      fontWeight: ToolBarManager().sort?.isByType == true
                          ? FontWeight.bold
                          : FontWeight.normal,
                    );
                  }),
            ),
          ),
          Container(
            width: 80,
            constraints: const BoxConstraints(minWidth: 56),
            alignment: Alignment.center,
            child: BaseText(
              title: 'Size',
            ),
          ),
          BaseButton(
            onPressed: _onFilterByModified,
            child: Container(
              constraints: const BoxConstraints(minWidth: 160),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(
                0,
                6,
                16,
                6,
              ),
              child: StreamBuilder<String>(
                  stream: ToolBarManager().toolBarStream,
                  builder: (context, snapshot) {
                    return BaseText(
                      title: 'Modified',
                      fontWeight: ToolBarManager().sort?.isDateAToZ == true ||
                              ToolBarManager().sort?.isDateZToA == true
                          ? FontWeight.bold
                          : FontWeight.normal,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void _onFilterName() {
    final currentSort = ToolBarManager().sort;
    if (currentSort?.isNameAToZ == true) {
      return ToolBarManager().setSort(SortModel(id: 2));
    }
    ToolBarManager().setSort(SortModel(id: 1));
  }

  void _onFilterByLength() {
    final currentSort = ToolBarManager().sort;
    if (currentSort?.isByLengthIncrement == true) {
      return ToolBarManager().setSort(SortModel(id: 7));
    }
    ToolBarManager().setSort(SortModel(id: 6));
  }

  void _onTypePressed() {
    ToolBarManager().setSort(SortModel(id: 3));
  }

  void _onFilterByModified() {
    final currentSort = ToolBarManager().sort;
    if (currentSort?.isDateAToZ == true) {
      return ToolBarManager().setSort(SortModel(id: 5));
    }
    ToolBarManager().setSort(SortModel(id: 4));
  }
}
