import 'dart:async';
import 'dart:io';

import 'package:device_explorer/src/model/progress_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_archive/flutter_archive.dart';

class SdkManager {
  SdkManager._();

  static final SdkManager _singleton = SdkManager._();

  factory SdkManager() => _singleton;

  StreamController<ProgressModel> controller = StreamController.broadcast();

  String get defaultAdbPath =>
      '${Platform.environment['HOME']}/Library/Android/sdk/platform-tools/adb';

  String get downloadAdbPath =>
      '${downloadPlatformToolDir.path}/platform-tools/adb';

  Directory get downloadPlatformToolDir =>
      Directory('${Platform.environment['HOME']}/.device-explore');

  File get downloadPlatformToolZipFile =>
      File('${downloadPlatformToolDir.path}/platform-tools.zip');

  Future<void> downloadIfNeeded() async {
    File adb = File(defaultAdbPath);
    if (adb.existsSync()) return;
    adb = File(downloadAdbPath);
    if (adb.existsSync()) return;
    await downloadPlatformTool();
    await extractPlatformTool();
    downloadPlatformToolZipFile.deleteSync();
  }

  Future<void> downloadPlatformTool() async {
    const url =
        'https://dl.google.com/android/repository/platform-tools-latest-darwin.zip?hl=vi';
    await Dio().download(url, downloadPlatformToolZipFile.path,
        onReceiveProgress: (count, total) {
      controller
          .add(ProgressModel(total: total.toDouble(), count: count.toDouble()));
    });
  }

  Future<void> extractPlatformTool() async {
    if (!downloadPlatformToolZipFile.existsSync()) return;
    await ZipFile.extractToDirectory(
        zipFile: downloadPlatformToolZipFile,
        destinationDir: downloadPlatformToolDir);
  }

  String get adb {
    File adb = File(defaultAdbPath);
    if (adb.existsSync()) return adb.path;
    adb = File(downloadAdbPath);
    return adb.path;
  }
}
