import 'dart:developer';

import 'package:device_explorer/src/common/ext/duration_ext.dart';
import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:device_explorer/src/page/wrapper/wrapper_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class FileAudioItem extends StatefulWidget {
  const FileAudioItem({super.key, this.file});
  final FileModel? file;
  @override
  State<FileAudioItem> createState() => _FileAudioItemState();
}

class _FileAudioItemState extends State<FileAudioItem> {
  AudioPlayer player = AudioPlayer();
  Duration? totalDuration;

  WrapperProvider get wrapperProvider => context.read<WrapperProvider>();
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final path = await widget.file?.getViewPath(device: wrapperProvider.currentTab.device);
    if (path == null) return;
    totalDuration = await player.setFilePath(path);
    log('${DateTime.now()}  totalDuration: $totalDuration', name: 'VERBOSE');
    player.play();
    setState(() {});
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white70,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
              stream: player.playerStateStream,
              builder: (_, __) => BaseButton(
                onPressed: _onAutoAction,
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    _getIcon(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            StreamBuilder(
              stream: player.positionStream,
              builder: (_, __) => BaseText(
                title: player.position.toDisplay(),
              ),
            ),
            BaseText(
              title: ' - ',
            ),
            BaseText(
              title: totalDuration?.toDisplay() ?? '00:00',
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 16,
              width: 250,
              child: StreamBuilder(
                stream: player.positionStream,
                builder: (_, __) => Slider(
                  value: player.position.inSeconds /
                      (totalDuration?.inSeconds ?? 1),
                  onChanged: _onChange,
                  onChangeEnd: _onChangeEnd,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onAutoAction() {
    if (player.playing) {
      player.pause();
    } else {
      if (player.playerState.processingState == ProcessingState.completed) {
        player.seek(Duration.zero);
      }
      player.play();
    }
    setState(() {});
  }

  void _onChange(double value) {
    player.pause();
    player.seek(
        Duration(seconds: ((totalDuration?.inSeconds ?? 0) * value).toInt()));
  }

  void _onChangeEnd(double value) {
    player.play();
  }

  IconData? _getIcon() {
    if (player.playerState.processingState == ProcessingState.completed) {
      player.pause();
      return Icons.play_arrow_rounded;
    }
    return player.playing ? Icons.pause : Icons.play_arrow_rounded;
  }
}
