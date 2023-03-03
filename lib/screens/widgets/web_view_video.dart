import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

///Web Video
class WebViewVideo extends StatefulWidget {
  ///
  const WebViewVideo({Key? key, required this.url, required this.height})
      : super(key: key);
  final String url;
  final double height;

  @override
  WebViewVideoState createState() => WebViewVideoState();
}

class WebViewVideoState extends State<WebViewVideo> {
  ///----WebViewX
  late VideoPlayerController _controller;
  late Future<void> videoPlayerFuture;
  bool _isPlaying = false;
  String currentDuration = '00:00';
  String totalDuration = '00:00';
  String videoUrl = '';

  @override
  void initState() {
    super.initState();
    initVideoInitialize(videoUrl: widget.url);
  }

  ///
  void initVideoInitialize({required String videoUrl}) {
    try {
      _controller = VideoPlayerController.network(
        videoUrl,
        formatHint: VideoFormat.hls,
      );

      _controller.addListener(_listenerFunc);
      videoPlayerFuture = _controller.initialize();
      _controller.setVolume(0.5);
    } catch (error) {
      debugPrint('---> error: $error');
    }
  }

  void _listenerFunc() {
    debugPrint('---> into _listenerFunc');
    try {
      final value = _controller.value;
      if (!value.isInitialized) {
        return;
      }

      if (value.hasError) {
        debugPrint('-> error: ${value.errorDescription} ');
      } else {
        // all is ok. let's go

        if (mounted) {
          debugPrint('-> call SetState to update video progress');
          setState(setVideoTime);
        }

        if (value.position == const Duration()) {
          debugPrint('-> video starts');
        }

        if (value.position == value.duration) {
          debugPrint('-> video ended');
        }

        //check video is playing or not
        if (value.isPlaying != _isPlaying) {
          if (mounted) {
            debugPrint('*** play/pause button update');
            setState(() {
              _isPlaying = value.isPlaying;
            });
          }
        }
      }
    } catch (error) {
      debugPrint('-> catch error: $error');
    }
    debugPrint('---> _listenerFunc ends');
    debugPrint(' ');
  }

  /// ### Defines for set video time.
  ///
  /// * Return nil or empty.
  void setVideoTime() {
    currentDuration = _getTimeFromDuration(_controller.value.position);
  }

  /// ### Defines for get Time From Duration logic.
  ///
  /// * [Duration] video play duration.
  ///
  /// * Return [String] convert in time.
  String _getTimeFromDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).toInt());
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).toInt());
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: videoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          totalDuration = _getTimeFromDuration(_controller.value.duration);
          return SizedBox(
            height: widget.height,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  videoCustomControls(context),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /// ### Defines for show video CustomControls widget.
  ///
  /// * Return [Column] Widget type for Common [Widget] class type.
  Column videoCustomControls(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Visibility(
          visible: true,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.black12.withOpacity(0.2),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                  child: Row(
                    children: [
                      Expanded(
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              bufferedColor: Colors.white38,
                              playedColor: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          '$currentDuration / $totalDuration',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      TextButton(
                        child: Icon(
                            _isPlaying
                                ? Icons.pause_sharp
                                : Icons.play_arrow_sharp,
                            color: Colors.white,
                            size: 30),
                        onPressed: () {
                          if (!_controller.value.hasError) {
                            if (mounted) {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                _isPlaying = _controller.value.isPlaying;
                              });
                            }
                          } else {
                            debugPrint('---> error: video_fail_message');
                          }
                          // pause while video is playing, play while video is pausing
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        child: const Icon(Icons.forward_10_sharp,
                            color: Colors.white, size: 30),
                        onPressed: () {
                          if (!_controller.value.hasError) {
                            if (mounted) {
                              setState(() {
                                Duration currentPosition =
                                    _controller.value.position;

                                /// check if video has ended
                                if (currentPosition.inSeconds ==
                                    _controller.value.duration.inSeconds) {
                                  _controller.seekTo(Duration.zero);
                                } else {
                                  _controller.seekTo((currentPosition +
                                      const Duration(seconds: 10)));
                                }
                              });
                            }
                          } else {
                            debugPrint('---> error: video_fail_message');
                          }
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.white,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8.0),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 10.0),
                          ),
                          child: Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.white12,
                            thumbColor: Colors.white,
                            min: 0.0,
                            max: 1.0,
                            onChanged: (newValue) {
                              if (mounted) {
                                setState(() {
                                  _controller.setVolume(newValue);
                                });
                              }
                            },
                            value: _controller.value.volume,
                          )),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_listenerFunc)
      ..dispose();

    super.dispose();
  }
}
