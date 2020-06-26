import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  VideoPlayerController _controller;
  String title;
  String url;

  @override
  void initState() { 
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      VideoArgs args = ModalRoute.of(context).settings.arguments;
      setState(() {
        title = args.title;
      });
      url = args.url;
      _controller = VideoPlayerController.network(url);
      await _controller.initialize();
      if(_controller.value.initialized) {
        setState(() {
          
        });
        _controller.play();
        _controller.value.aspectRatio > 1
          ? SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
          : SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      }
      
    });
  }

  @override
  void dispose() { 
    _controller.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: _controller.value.initialized ? 
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        :
        Center(child: CircularProgressIndicator(),),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
    );
  }
}

class VideoArgs {
  final String title, url;

  VideoArgs({this.title, this.url});
}