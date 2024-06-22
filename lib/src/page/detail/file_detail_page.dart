import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/common/widgets/app_back_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/detail/file_detail_provider.dart';
import 'package:device_explorer/src/page/detail/widget/file_audio_item.dart';
import 'package:device_explorer/src/page/detail/widget/file_image_item.dart';
import 'package:device_explorer/src/page/detail/widget/file_pdf_item.dart';
import 'package:device_explorer/src/page/detail/widget/file_video_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FileDetailPageArgs {
  List<FileModel>? files;
  int? initIndex = 0;
  FileDetailPageArgs({
    this.files,
    this.initIndex,
  });
}

class FileDetailPage extends StatefulWidget {
  const FileDetailPage({super.key});

  @override
  State<FileDetailPage> createState() => _FileDetailPageState();
}

class _FileDetailPageState
    extends BaseState<FileDetailPage, FileDetailProvider> {
  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: provider.onKeyEvent,
        child: Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                controller: provider.controller,
                itemBuilder: _buildItem,
                itemCount: provider.args?.files?.length,
              ),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(16))),
                  child: Consumer<FileDetailProvider>(
                    builder: (_, p, __) => BaseText.bold(
                      title:
                          '${(provider.controller.page?.toInt() ?? provider.args?.initIndex ?? 0) + 1}/${provider.args?.files?.length}',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Consumer<FileDetailProvider>(builder: (context, value, child) {
                if (provider.currentFile == null) {
                  return const SizedBox();
                }
                return Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BaseText.bold(
                      title: provider.currentFile?.path,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
               Padding(
                padding: EdgeInsets.all(16.0),
                child: Opacity(
                  opacity: .3,
                  child: AppBackButton(onBackPressed: _onBackPressed,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  FileDetailProvider get registerProvider => FileDetailProvider();

  Widget? _buildItem(BuildContext context, int index) {
    final item = provider.args?.files?.elementAt(index);
    if (item?.isImage ?? false) {
      return FileImageItem(
        file: item,
      );
    }
    if (item?.isVideo ?? false) {
      return FileVideoItem(
        file: item,
      );
    }
    if (item?.isAudio ?? false) {
      return FileAudioItem(
        file: item,
      );
    }
    if (item?.isPdf ?? false) {
      return FilePdfItem(
        file: item,
      );
    }
    return Center(
        child: BaseText(
      title: 'Not support open: ${item?.name}',
      fontSize: 32,
    ));
  }

  void _onBackPressed() {
    context.pop(args: provider.controller.page?.toInt());
  }
}
