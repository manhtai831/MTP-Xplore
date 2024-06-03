import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/base_response.dart';
import 'package:device_explorer/src/model/progress_model.dart';
import 'package:device_explorer/src/page/dialog/pull_progress/pull_progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PullProgressDialog extends StatefulWidget {
  const PullProgressDialog({super.key});

  @override
  State<PullProgressDialog> createState() => _PullProgressDialogState();
}

class _PullProgressDialogState
    extends BaseState<PullProgressDialog, PullProgressProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<PullProgressProvider>(
                builder: (_, p, __) => TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween<double>(begin: 0, end: _getProgress()),
                  builder: (_, value, __) => LinearProgressIndicator(
                    value: value,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Consumer<PullProgressProvider>(
                builder: (_, p, __) => BaseText(
                  title: _getContentText(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  PullProgressProvider get registerProvider => PullProgressProvider();

  double _getProgress() {
    if (provider.currentPull is ProgressModel) {
      return (provider.currentPull as ProgressModel).getProgress();
    }
    if (provider.currentPull is BaseResponse<String>) {
      return 1;
    }
    return 0;
  }

  String _getContentText() {
    if (provider.currentPull is ProgressModel) {
      return (provider.currentPull as ProgressModel).getStatusText();
    }
    if (provider.currentPull is BaseResponse<String>) {
      return 'Pulled: ${(provider.currentPull as BaseResponse<String>).raw ?? 'Done'}';
    }
    return '';
  }
}
