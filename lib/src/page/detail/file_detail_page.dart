import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/detail/file_detail_provider.dart';
import 'package:device_explorer/src/page/detail/widget/file_image_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileDetailPageArgs {
  List<FileModel>? files;
  FileDetailPageArgs({
    this.files,
  });
}

class FileDetailPage extends StatefulWidget {
  const FileDetailPage({super.key});

  @override
  State<FileDetailPage> createState() => _FileDetailPageState();
}

class _FileDetailPageState
    extends BaseState<FileDetailPage, FileDetailProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        body: PageView.builder(
          itemBuilder: _buildItem,
          itemCount: provider.args?.files?.length,
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
    return const SizedBox();
  }
}
