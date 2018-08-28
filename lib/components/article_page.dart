import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';

enum PlayerState { playing, paused, stopped }

class ArticlePage extends StatefulWidget {
  final String articleId;
  final String name;
  final String topicId;
  final String video;
  final String audio;
  final String image;
  final String text;
  final int serial;

  ArticlePage({
    Key key,
    @required this.articleId,
    @required this.name,
    @required this.topicId,
    @required this.video,
    @required this.audio,
    @required this.image,
    @required this.text,
    @required this.serial,
  }) : super(key: key);

  @override
  _ArticlePageState createState() {
    return new _ArticlePageState();
  }
}

class _ArticlePageState extends State<ArticlePage> {
  AudioPlayer audioPlayer = new AudioPlayer();
  File audioFile;
  PlayerState playerState;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future _loadAsset(String sample) async {
    return await rootBundle.load('assets/$sample.wav');
  }

  Future _initAudioPlayer() async {
    playerState == PlayerState.stopped;
    try {
      final String path = await _localPath;
      final File file = new File('$path/sample.wav');
      audioFile = file;
    } catch (e) {}
  }

  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  void play() async {
    await audioFile
        .writeAsBytes((await _loadAsset('lion')).buffer.asUint8List());
    await audioPlayer.play(audioFile.path, isLocal: true);
  }

  void pause() async {
    if (await audioFile.exists()) {
      print('file exist');
      await audioPlayer.pause();
    }
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      print("Size ${constraints.maxHeight} , ${constraints.maxWidth}");
      return Material(
        type: MaterialType.transparency,
        child: new Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
          ),
          child: new Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: new Container(
                  width: constraints.maxWidth * 0.992,
                  height: constraints.maxHeight * 0.732,
                  color: Colors.red,
                  child: FittedBox(
                    child: new Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: new RawMaterialButton(
                  shape: new CircleBorder(),
                  fillColor: Colors.white,
                  splashColor: Colors.teal,
                  highlightColor: Colors.teal.withOpacity(0.5),
                  elevation: 10.0,
                  highlightElevation: 5.0,
                  onPressed: () {
                    if (playerState == PlayerState.stopped ||
                        playerState == PlayerState.playing) {
                      pause();
                      setState(() {
                        playerState = PlayerState.paused;
                      });
                    } else {
                      play();
                      setState(() {
                        playerState = PlayerState.playing;
                      });
                    }
                  },
                  child: new Icon(
                    (playerState == PlayerState.stopped ||
                            playerState == PlayerState.playing)
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.purple,
                    size: 40.0,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: new Container(
                    color: Colors.grey,
                    child: new Markdown(
                      data: widget.text,
                    )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
