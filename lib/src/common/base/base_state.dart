import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class BaseState<T extends StatefulWidget, P extends BaseProvider>
    extends State<T> {
  late P provider;

  P get registerProvider;

  @override
  void initState() {
    super.initState();
    provider = registerProvider;
    provider.context = context;
    showLog('Push: $runtimeType');

    provider.init();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      provider.mounted = true;
      provider.onViewCreated();
    });
  }

  @override
  void dispose() {
    provider.mounted = false;
    provider.destroy();
    super.dispose();
  }
}
