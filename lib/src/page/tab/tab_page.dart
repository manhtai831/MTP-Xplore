import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/widgets/app_header.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:device_explorer/src/page/device/device_page.dart';
import 'package:device_explorer/src/page/file/file_page.dart';
import 'package:device_explorer/src/page/tab/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabPageArgs {
  TabModel? tab;
  TabPageArgs({
    this.tab,
  });
}

class TabPage extends StatefulWidget {
  const TabPage({super.key, this.args});
  final TabPageArgs? args;
  @override
  State<TabPage> createState() => _TabPageState();
}

Map<TabModel, TabProvider> cacheProvider = {};

class _TabPageState extends BaseState<TabPage, TabProvider>
    with AutomaticKeepAliveClientMixin {
  @override
  TabProvider get registerProvider {
    cacheProvider[widget.args!.tab!] ??= TabProvider()..args = widget.args;
    return cacheProvider[widget.args!.tab!]!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        body: Stack(
          children: [
            Selector<TabProvider, bool>(
              selector: (p0, p1) => p1.tab.directory == null,
              shouldRebuild: (previous, next) => previous != next,
              builder: (_, data, ___) =>
                  data ? const DevicePage() : const FilePage(),
            ),
            BaseText.bold(
              title: hashCode.toString(),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
