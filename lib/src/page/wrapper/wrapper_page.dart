import 'dart:developer';

import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:device_explorer/src/page/tab/tab_page.dart';
import 'package:device_explorer/src/page/wrapper/widgets/add_tab_widget.dart';
import 'package:device_explorer/src/page/wrapper/widgets/item_tab.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatefulWidget {
  const WrapperPage({super.key});

  @override
  State<WrapperPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends BaseState<WrapperPage, WrapperProvider> {
  @override
  WrapperProvider get registerProvider => context.read<WrapperProvider>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 42),
                    child: Selector<WrapperProvider, List<TabModel>>(
                      selector: (p0, p1) => p1.tabs,
                      shouldRebuild: (previous, next) {
                        return true;
                      },
                      builder: (_, __, ___) => ListView.builder(
                        itemBuilder: _buildTab,
                        itemCount: provider.tabs.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                ),
                AddTabWidget(
                  onPressed: provider.addTab,
                ),
              ],
            ),
            Expanded(
              child: Selector<WrapperProvider, List<TabModel>>(
                selector: (p0, p1) => p1.tabs,
                shouldRebuild: (previous, next) => true,
                builder: (_, __, ___) => PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: provider.controller,
                  itemBuilder: _buildItem,
                  itemCount: provider.tabs.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildTab(BuildContext context, int index) {
    final item = provider.tabs.elementAt(index);
    return ItemTab(
      item: item,
      onPressed: () => provider.onTabPressed(item),
      onClosePressed: () => provider.removeTab(item),
    );
  }

  Widget? _buildItem(BuildContext context, int index) {
    final item = provider.tabs.elementAt(index);
    return TabPage(
      key: item.key,
      args: TabPageArgs(tab: item),
    );
  }
}
