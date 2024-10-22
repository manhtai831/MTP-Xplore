import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/model/directory_model.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:flutter/material.dart';

class WrapperProvider extends BaseProvider {
  final List<TabModel> tabs = [];
  PageController controller = PageController();

  @override
  Future<void> init() async {
    addTab();
  }

  void addTab() {
    unselectedAll();
    tabs.add(TabModel());
    notify();
    navigateToCurrentPage();
  }

  void removeTab(TabModel tab) {
    if (tabs.length == 1) return;
    int index = tabs.indexOf(tab);
    final tab0 = currentTab;
    tabs.remove(tab);
    notify();
    if (tab != tab0) {
      index = tabs.indexOf(tab0);
      navigateToCurrentPage(index: index);
    } else {
      unselectedAll();
      if (tabs.length == 1) {
        index = 0;
      }
      navigateToCurrentPage(index: index);
      tabs[index].isSelected = true;
      notify();
    }
  }

  void unselectedAll() {
    for (var it in tabs) {
      it.isSelected = false;
      it.focusNode.unfocus();
    }
  }

  TabModel get currentTab => tabs.firstWhere((it) => it.isSelected == true);
  int get currentTabIndex => tabs.indexWhere((it) => it.isSelected == true);

  void onTabPressed(TabModel item) {
    if (item.isSelected) return;
    unselectedAll();
    item.isSelected = true;
    notify();
    navigateToCurrentPage();
  }

  void navigateToCurrentPage({int? index}) {
    if (mounted) controller.jumpToPage(index ?? currentTabIndex);
    currentTab.focusNode.requestFocus();
  }

  void updateDir(DirectoryModel? dir) {
    currentTab.directory = dir;
    notify();
  }

  bool get isSystem => currentTab.device?.isSystem == true;
}
