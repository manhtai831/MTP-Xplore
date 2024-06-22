import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:device_explorer/src/shell/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class FileVideoItem extends StatefulWidget {
  const FileVideoItem({super.key, this.file});
  final FileModel? file;
  @override
  State<FileVideoItem> createState() => _FileVideoItemState();
}

class _FileVideoItemState extends State<FileVideoItem> {
  ChewieController? _chewieController;
  WrapperProvider get wrapperProvider => context.read<WrapperProvider>();
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    String? path = await getPath();
    log('${DateTime.now()}  path: $path', name: 'VERBOSE');
    if (path == null) return;
    final file = File(path);
    if (file.statSync().size == 0) {
      return;
    }
    VideoPlayerController? controller = VideoPlayerController.file(file);
    await controller.initialize();
    _chewieController = ChewieController(
      videoPlayerController: controller,
      autoPlay: false,
    );
    if (mounted) setState(() {});
  }

  Future<String?> getPath() async {
    String? path = wrapperProvider.isSystem
        ? widget.file?.path
        : '${(await getApplicationSupportDirectory()).path}/${widget.file?.name?.split('/').lastOrNull}';
    if (File(path!).existsSync()) {
      return path;
    }
    final result = await FileManager().pull(filePath: widget.file?.path ?? '');
    if (result.isOke()) {
      path = result.data;
    } else {
      path = result.data?.split(":").firstOrNull;
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Chewie(
      controller: _chewieController!,
    );
  }

  @override
  void dispose() {
    _chewieController?.videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
