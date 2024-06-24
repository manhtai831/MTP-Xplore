// ignore_for_file: use_build_context_synchronously

import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/manager/sdk/sdk_manager.dart';
import 'package:device_explorer/src/common/route/route_path.dart';
import 'package:device_explorer/src/model/progress_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkDownloadSdk();
    });
  }

  Future<void> checkDownloadSdk() async {
    try {
      await SdkManager().downloadIfNeeded();
      context.push(RoutePath.wrapper, replace: true);
    } catch (e) {
      Application.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<ProgressModel>(
            stream: SdkManager().controller.stream,
            initialData: ProgressModel(total: 1, count: 0),
            builder: (context, snapshot) {
              return CircularProgressIndicator(
                value: snapshot.data?.getProgress(),
              );
            }),
      ),
    );
  }
}
