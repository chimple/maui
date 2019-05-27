import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  final File file;
  final int gameCategoryId;
  const VideoApp({Key key, this.file, this.gameCategoryId}) : super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.file)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    print("hello data i have to check..rrrrrrrr.::${widget.file}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    Orientation orientation = MediaQuery.of(context).orientation;

    // left: media.size.width-50.0,
    //           top: media.size.height/4.3,
    var posl = orientation == Orientation.portrait
        ? media.size.width / 1.3
        : media.size.width / 1.25;
    var post = orientation == Orientation.portrait
        ? media.size.height / 4.3
        : media.size.height / 5;
    print(
        "hello this  is the data for how its  going.....::...${_controller.value.initialized}");
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        //  appBar: new AppBar(
        //   title: new Row(
        //     children: <Widget>[
        //       IconButton(
        //         onPressed: (){ Navigator.of(context).pop();},
        //         icon: Icon(Icons.arrow_back),

        //       ),
        //       new Text("demo video"),
        //     ],
        //   ),

        // ),

        body: Container(
          height: media.size.height,
          width: media.size.width,
          child: Stack(children: [
            Container(
              height: media.size.height,
              width: media.size.width,
              color: Colors.white,
            ),
            GestureDetector(
              onTap: _controller.value.isPlaying
                  ? _controller.pause
                  : _controller.play,
              child: Center(
                child: _controller.value.initialized
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Container(
                            height: media.size.height / 2,
                            width: media.size.width / 1.5,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Container(
                              height: media.size.height / 2,
                              width: media.size.width / 1.5,
                              child: VideoPlayer(_controller)),
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: _controller.value.isPlaying
                  ? _controller.pause
                  : _controller.play,
              child: Center(
                child: new Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: new Center(
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 60.0,
                    ),
                  ),
                ),
              ),
            ),
            new Positioned(
              left: posl,
              top: post,
              child: GestureDetector(
                onTap: _controller.value.isPlaying
                    ? _controller.pause
                    : _controller.pause,
                child: GestureDetector(
                  onTap: () {
                    print("hello");

                    _controller.pause();
                    Navigator.of(context).pop();
                  },
                  child: new Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: new Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _controller.value.isPlaying
        //       ? _controller.pause
        //       : _controller.play,
        //   child: Icon(
        //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        //   ),
        // ),
      ),
    );
  }
}
