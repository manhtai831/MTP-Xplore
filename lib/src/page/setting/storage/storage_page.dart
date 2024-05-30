import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/common/widgets/app_back_button.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/page/file/widget/file_item.dart';
import 'package:device_explorer/src/page/setting/storage/storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends BaseState<StoragePage, StorageProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: BaseText.bold(
            title: 'Storage Manage',
          ),
        ),
        body: Consumer<StorageProvider>(
          builder: (_, p, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      title: 'Path: ${provider.currentPath ?? '--'}',
                    ),
                    BaseText(
                      title:
                          'Current size: ${provider.dirStat?.sizeFile ?? '--'} ${provider.dirStat?.sizeText}',
                    ),
                    BaseButton(
                      onPressed: provider.clearStorage,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              IconPath.clear,
                              width: 32,
                            ),
                            const SizedBox( width: 12),
                            BaseText.bold(
                              title: 'Clear storage',
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: _buildItem,
                itemCount: provider.files.length,
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  StorageProvider get registerProvider => StorageProvider();

  Widget? _buildItem(BuildContext context, int index) {
    final file = provider.files.elementAt(index);
    return FileItem(
      file: file,
    );
  }
}
