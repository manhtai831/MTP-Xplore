import 'dart:io';

import 'package:device_explorer/src/model/file_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            height: size?.height,
          );
        } else {
          return Image.file(
            File(file!.path!),
            width: size?.width,
              height: size?.height,
          );
        }
      }
    }
    return Image.asset(
      file?.icon ?? '',
      width: size?.width,
        height: size?.height,
    );
  }
}
