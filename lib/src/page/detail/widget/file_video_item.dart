import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:flutter/material.dart';
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
    String? path = await widget.file?.getViewPath(device: wrapperProvider.currentTab.device);
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
