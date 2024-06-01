import 'dart:developer';

import 'package:device_explorer/src/common/res/icon_path.dart';

class FileModel {
  String? permission;
  int? childCount;
  String? user;
  String? group;

  /// Size in bytes
  double? size;
  DateTime? created;
  String? name;
  int countCal = 1;
  bool isSelected = false;

  FileModel({
    this.permission,
    this.childCount,
    this.user,
    this.group,
    this.size,
    this.created,
    this.name,
  });

  String get sizeFile {
    countCal = 1;
    return '${calculateSize(size ?? 0).toStringAsFixed(2)} $sizeText';
  }

  String get sizeText {
    if (countCal == 1) {
      return 'KB';
    } else if (countCal == 2) {
      return 'MB';
    } else if (countCal == 3) {
      return 'GB';
    } else {
      return 'TB';
    }
  }

  double calculateSize(double cSize) {
    double calSize = cSize / 1024;
    if (calSize < 1024) {
      return calSize;
    }
    countCal++;
    return calculateSize(calSize);
  }

  bool get isDir => permission?.startsWith('d') ?? false;
  bool get isLink => permission?.startsWith('l') ?? false;
  bool get isFile => permission?.startsWith('-') ?? false;
  bool get isImage => ['jpg', 'png', 'jpeg', 'svg'].contains(ext);
  bool get isVideo => ['mp4'].contains(ext);
  bool get isPdf => ['pdf'].contains(ext);

  String? get linkTo {
    final splits = name?.split('->').lastOrNull?.split('/');
    String? link = splits?.sublist(0, splits.length - 1).join('/');
    return link;
  }

  bool get isBack => name == '.' || name == '..';

  String? get ext {
    if (isDir) return 'dir';
    if (isLink) return 'link';
    if (!isFile) return null;
    return name?.split('.').lastOrNull;
  }

  String get icon {
    if (isDir) {
      return IconPath.folder;
    }
    if (isLink) {
      return IconPath.link;
    }
    if (isFile) {
      if (isPdf) {
        return IconPath.pdf;
      } else if (ext == 'apk') {
        return IconPath.apk;
      } else if (['zip', 'rar', '7zip'].contains(ext)) {
        return IconPath.zip;
      } else if (isImage) {
        return IconPath.image;
      } else if (isVideo) {
        return IconPath.video;
      } else {
        return IconPath.file;
      }
    }
    return IconPath.unknown;
  }
// lrw-r--r--    1 root   root        11 2009-01-01 07:00 bin -> /system/bin

  String dateDisplay() {
    try {
      return created.toString().substring(0, 19);
    } catch (e) {
      return created?.toString() ?? '?';
    }
  }

  FileModel.fromString(String s) {
    Iterable<String> splits = s.split(' ').where((it) => it.isNotEmpty);
    if (splits.isEmpty) return;
    permission = splits.elementAt(0);
    childCount = int.tryParse(splits.elementAt(1));
    user = splits.elementAt(2);
    group = splits.elementAt(3);
    size = double.tryParse(splits.elementAt(4));
    created =
        DateTime.tryParse('${splits.elementAt(5)} ${splits.elementAt(6)}');
    name = splits.skip(7).join(' ');
  }

  @override
  String toString() {
    return 'FileModel(permission: $permission, childCount: $childCount, user: $user, group: $group, size: $size, created: $created, name: $name)';
  }
}
