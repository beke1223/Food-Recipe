// Create a custom widget that wraps the FutureBuilder and adds the desired functionality
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExpandedVideoPlayer extends StatefulWidget {
  final Future<void>?  initializeVideoPlayerFuture;
    

  final VideoPlayerController videoUrl;

  const ExpandedVideoPlayer({
    Key? key,
    required this.initializeVideoPlayerFuture,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _ExpandedVideoPlayerState createState() => _ExpandedVideoPlayerState();
}

class _ExpandedVideoPlayerState extends State<ExpandedVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    await widget.initializeVideoPlayerFuture;
    setState(() {
      _controller = VideoPlayerController.networkUrl(widget.videoUrl as Uri);
    });
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  content: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller),
                        Positioned(
                          bottom: 16.0,
                          left: 16.0,
                          right: 16.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _controller.seekTo(
                                    Duration(
                                      seconds: _controller.value.position.inSeconds -
                                          10,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.fast_rewind),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                },
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _controller.seekTo(
                                    Duration(
                                      seconds: _controller.value.position.inSeconds +
                                          10,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.fast_forward),
                              ),
                              Slider(
                                value: _controller.value.volume,
                                onChanged: (value) {
                                  _controller.setVolume(value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}