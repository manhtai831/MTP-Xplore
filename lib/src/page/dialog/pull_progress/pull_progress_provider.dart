import 'dart:async';

import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/shell/file_manager.dart';

class PullProgressProvider extends BaseProvider {
  StreamSubscription? _subscription;

  dynamic /* BaseResponse | ProgressModel */ currentPull;
  @override
  Future<void> init() async {
    _subscription = FileManager().pullController.stream.listen(_pullListener);
  }

  void _pullListener(event) {
    currentPull = event;
    notify();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
