import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/file/widget/image_placeholder.dart';
import 'package:flutter/material.dart';

class FileItem extends StatelessWidget {
  const FileItem({super.key, this.file, this.onPressed, this.onDoubleTap});
  final FileModel? file;
  final VoidCallback? onPressed;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onPressed,
      onDoubleTap: onDoubleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: file?.isSelected == true
                ? Theme.of(context).primaryColor.withOpacity(.3)
                : null,
            border: const Border(
                bottom: BorderSide(width: .5, color: Colors.black12))),
        child: Row(
          children: [
            ImagePlaceholder(
              file: file,
              size: const Size.square(32),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: BaseText.bold(
                title: file?.name ?? '?',
              ),
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 56),
              alignment: Alignment.centerRight,
              child: BaseText(
                title: file?.sizeFile.toString() ?? '?',
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 56),
              alignment: Alignment.centerRight,
              child: BaseText(
                title: file?.ext ?? '?',
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 56),
              alignment: Alignment.centerRight,
              child: BaseText(
                title: file?.childCount?.toString() ?? '?',
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 160),
              alignment: Alignment.centerRight,
              child: BaseText(
                title: file?.dateDisplay() ?? '?',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
