import 'dart:io';

import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/tab/tab_provider.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    this.file,
    this.size,
  });
  final FileModel? file;
  final Size? size;
  @override
  Widget build(BuildContext context) {
    if (file?.isSystem == true) {
      if (file?.isImage == true) {
        if (file?.isSvg == true) {
          return SvgPicture.file(
            File(file!.path!),
            width: size?.width,
          );
        } else {
          return Image.file(
            File(file!.path!),
            width: size?.width,
          );
        }
      }
    }
    return Image.asset(
      file?.icon ?? '',
      width: size?.width,
    );
  }
}
