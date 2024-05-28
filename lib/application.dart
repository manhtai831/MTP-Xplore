import 'package:device_explorer/src/common/base/settings_observer.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/common/widgets/app_header.dart';
import 'package:device_explorer/src/page/detail/file_detail_page.dart';
import 'package:device_explorer/src/page/device/device_page.dart';
import 'package:device_explorer/src/page/file/file_page.dart';
import 'package:flutter/material.dart';

class Application extends StatefulWidget {
  const Application({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

  static void showSnackBar(String? msg) {
    Application.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          msg ?? '',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
      builder: (context, child) => ScaffoldMessenger(
        key: Application.scaffoldMessengerKey,
        child: Listener(
          child: Column(
            children: [
              const AppHeader(),
              Expanded(child: child ?? const SizedBox()),
            ],
          ),
        ),
      ),
    );
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

extension ApplicationExt on Application {}
