import 'dart:io';

import 'package:device_explorer/src/common/res/icon_path.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:path_provider/path_provider.dart';

class FileModel {
  String? permission;
  int? childCount;
  String? user;
  String? group;
  // init path is null
  String? path;
  bool? isSystem;

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
  bool get isImage => ['jpg', 'png', 'jpeg', 'svg', 'gif'].contains(ext);
  bool get isSvg => ['svg'].contains(ext);
  bool get isVideo => ['mp4', 'm4v'].contains(ext);
  bool get isAudio => ['mp3'].contains(ext);
  bool get isIpa => ['ipa'].contains(ext);
  bool get isPdf => ['pdf'].contains(ext);
  bool get isJson => ['json'].contains(ext);
  bool get isZip => ['zip', 'rar', '7zip'].contains(ext);

  String? getName() {
    if (isDir) {
      return name;
    }
    if (isLink) {
      final split = name?.split(' -> ').firstOrNull;
      return '$split/';
    }
    return null;
  }

  String? getNameWithoutExt() {
    final splits = name?.split('.');
    splits?.removeLast();
    return splits?.join('_');
  }

  String? get linkTo {
    final splits = name?.split('->').lastOrNull?.split('/');
    String? link = splits?.sublist(0, splits.length - 1).join('/');
    return link;
  }

  String? get parentPath {
    final splits = path?.split('/');
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
      } else if (isZip) {
        return IconPath.zip;
      } else if (isImage) {
        return IconPath.image;
      } else if (isVideo) {
        return IconPath.video;
      } else if (isIpa) {
        return IconPath.ipa;
      } else if (isAudio) {
        return IconPath.mp3;
      } else if (isAudio) {
        return IconPath.mp3;
      } else if (isJson) {
        return IconPath.json;
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

  void joinPath(String prefixPath) {
    if (!prefixPath.endsWith('/')) {
      prefixPath = '$prefixPath/';
    }
    path = '$prefixPath$name';
  }

  Future<String?> getViewPath() async {
    String? path = isSystem == true
        ? this.path
        : '${(await getApplicationSupportDirectory()).path}/${name?.split('/').lastOrNull}';
    if (File(path!).existsSync()) {
      return path;
    }
    final result = await FileManager().pull(filePath: this.path ?? '');
    if (result.isOke()) {
      path = result.data;
    } else {
      path = result.data?.split(":").firstOrNull;
    }
    return path;
  }

  FileModel.fromString(String s, {bool isFileSystem = false}) {
    Iterable<String> splits = s.split(' ').where((it) => it.isNotEmpty);
    if (splits.isEmpty) return;
    permission = splits.elementAt(0);
    childCount = int.tryParse(splits.elementAt(1));
    user = splits.elementAt(2);
    group = splits.elementAt(3);
    size = double.tryParse(splits.elementAt(4));
    created =
        DateTime.tryParse('${splits.elementAt(5)} ${splits.elementAt(6)}');
    name = splits.skip(isFileSystem ? 8 : 7).join(' ');
  }

  @override
  String toString() {
    return 'FileModel(permission: $permission, childCount: $childCount, user: $user, group: $group, size: $size, created: $created, name: $name)';
  }
}
