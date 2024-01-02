import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerWidget extends StatefulWidget {
  final String? videoPath;

  const VideoPlayerWidget({this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath!))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }



  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
      onTap: (){

      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          const Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.play_arrow,
                size: 54,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}