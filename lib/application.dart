import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/base/settings_observer.dart';
import 'package:device_explorer/src/common/manager/path/path_manager.dart';
import 'package:device_explorer/src/common/manager/tool_bar/select_mode.dart';
import 'package:device_explorer/src/common/manager/tool_bar/tool_bar_manager.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/setting_model.dart';
import 'package:device_explorer/src/page/detail/file_detail_page.dart';
import 'package:device_explorer/src/page/device/device_page.dart';
import 'package:device_explorer/src/page/dialog/sort/sort_dialog.dart';
import 'package:device_explorer/src/page/file/file_page.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Application extends StatefulWidget {
  const Application({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Application.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Device Explore',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorObservers: [
        SettingsObserver(),
      ],
      onGenerateRoute: _onGenerateRoute,
      initialRoute: RoutePath.devices,
      builder: (context, child) => Listener(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  BaseButton(
                    onPressed: () {
                      if (PathManager().paths.isNotEmpty) {
                        if (SettingModel().settings?.name !=
                            RoutePath.fileDetail) {
                          PathManager().remove();
                        }

                        Application.navigatorKey.currentContext?.pop();
                      }
                    },
                    child: Image.asset(
                      IconPath.back,
                      width: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: StreamBuilder<String>(
                      stream: PathManager().stream,
                      builder: (_, snapshot) => BaseText(
                        title: PathManager().toString(),
                      ),
                    ),
                  ),
                  BaseButton(
                    onPressed: _onUpload,
                    child: Image.asset(
                      IconPath.upload,
                      width: 32,
                    ),
                  ),
                 
                  const SizedBox(
                    width: 12,
                  ),
                  BaseButton(
                    onPressed: _onDownload,
                    child: Image.asset(
                      IconPath.download,
                      width: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  BaseButton(
                    onPressed: _onSort,
                    child: Image.asset(
                      IconPath.sort,
                      width: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  BaseButton(
                    onPressed: _onSetting,
                    child: Image.asset(
                      IconPath.setting,
                      width: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  BaseButton(
                    onPressed: ToolBarManager().onReload,
                    child: Image.asset(
                      IconPath.reload,
                      width: 32,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: child ?? const SizedBox()),
          ],
        ),
      ),
    );
  }

  void _onSetting() {}

  void _onSort() {
    showDialog(
      context: Application.navigatorKey.currentContext!,
      builder: (context) => const SortDialog(),
    );
  }

  Future<void> _onDownload() async {
    if (ToolBarManager().filePicked.isEmpty) {
      return;
    }
    final downloadDir = await getDownloadsDirectory();
    String? path = await FilesystemPicker.open(
      title: 'Save to folder',
      context: Application.navigatorKey.currentContext!,
      rootDirectory: downloadDir,
      fsType: FilesystemType.folder,
      pickText: 'Save file to this folder',
    );
    if (path == null) return;
    for (var it in ToolBarManager().filePicked) {
      await FileManager().pull(
          filePath: '${PathManager().toString()}/${it.name}', toPath: path);
    }
  }

  Future<void> _onUpload() async {
    final downloadDir = await getDownloadsDirectory();
    String? path = await FilesystemPicker.open(
      title: 'Open file/folder',
      context: Application.navigatorKey.currentContext!,
      rootDirectory: downloadDir,
      fsType: FilesystemType.all,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    if (path == null) return;
    FileManager().push(filePath: path, toPath: PathManager().toString());
  }
}

Map<String, Widget> _routes = {
  RoutePath.devices: const DevicePage(),
  RoutePath.files: const FilePage(),
  RoutePath.fileDetail: const FileDetailPage(),
};

Route? _onGenerateRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) => _routes[settings.name] ?? const SizedBox(),
    settings: settings,
  );
}
