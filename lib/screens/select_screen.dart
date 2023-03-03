import 'package:flutter/material.dart';
import 'package:play_video/navigation.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('video_player: 2.4.7'),
      ),
      body: SafeArea(
        child: _bodyWidgets(context),
      ),
    );
  }

  Widget _bodyWidgets(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _button(
                    'video1',
                    //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                    'https://videodelivery.net/5a975adb14c5eea94f15f28615b26621/manifest/video.m3u8?clientBandwidthHint=32.0'),
                const SizedBox(height: 5),
                const Text(
                    'a) freezes from 00:03 to 00:06, 1 sec. nothing happens, then plays from 00:07 to the end without any problems',
                    maxLines: 8),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _button('video2',
                    'https://videodelivery.net/cd6e717b1a37bff4c31d2fa8868f2363/manifest/video.m3u8'),
                const SizedBox(height: 5),
                const Text(
                    'a) freezes from 00:03 to 00:06, 1 sec. nothing happens, then plays from 00:07 to the end without any problems',
                    maxLines: 8),
                const SizedBox(height: 5),
                const Text(
                    'b) endless listener. video ends, but listener is still alive and continue to update screen',
                    maxLines: 8),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _button('video3',
                    'https://videodelivery.net/bd684c243ddfb500006c9bbc2917537f/manifest/video.m3u8'),
                const SizedBox(height: 5),
                const Text('Perfect. Works like expected', maxLines: 8),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _button('video4',
                    'https://videodelivery.net/fff5313890cb5ebcaa303d00ad594ace/manifest/video.m3u8?clientBandwidthHint=32.0'),
                const SizedBox(height: 5),
                const Text(
                    'Works like expected, but... endless listener :). video ends, but listener is still alive and continue to update screen',
                    maxLines: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String caption, String path) {
    return ElevatedButton(
      onPressed: () => NavigationActions.instance.pushVideoScreen(path),
      child: Text(caption),
    );
  }
}
