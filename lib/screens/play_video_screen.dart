import 'package:flutter/material.dart';
import 'package:play_video/screens/widgets/web_view_video.dart';

class PlayVideoScreen extends StatefulWidget {
  const PlayVideoScreen({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play me from web'),
      ),
      body: SafeArea(
        child: _bodyWidgets(context),
      ),
    );
  }

  Widget _bodyWidgets(BuildContext context) {
    return Center(
      child: WebViewVideo(
        url: widget.path,
        height: 250,
      ),
    );
  }
}
