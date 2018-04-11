import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/repos/unit_repo.dart';

class FlashCard extends StatefulWidget {
  final String text;
  final VoidCallback onChecked;

  FlashCard({Key key, @required this.text, this.onChecked}) : super(key: key);

  @override
  _FlashCardState createState() {
    return new _FlashCardState();
  }
}

class _FlashCardState extends State<FlashCard> {
  Unit _unit;
  bool _isLoading = true;
  bool _isPlaying = false;
  AudioPlayer audioPlayer;

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();

    audioPlayer.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
      });
    });
    play();
  }

  void play() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final result = await audioPlayer
        .play(join(documentsDirectory.path, "apple.ogg"), isLocal: true);
    if (result == 1) setState(() => _isPlaying = true);
  }

  @override
  void initState() {
    super.initState();
    _getData();
    initAudioPlayer();
  }

  void _getData() async {
    _unit = await new UnitRepo().getUnit(widget.text);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new Card(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new Container(
              alignment: const Alignment(0.0, 0.0),
              padding: const EdgeInsets.all(8.0),
              color: Colors.teal,
              child: new Text(_unit?.name ?? widget.text,
                  style: new TextStyle(color: Colors.white, fontSize: 24.0))),
          new Expanded(
              child: new Row(
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.volume_up),
                  onPressed: _isPlaying
                      ? null
                      : () {
                          play();
                        }),
              new Expanded(child: new Image.asset('assets/apple.png')),
              new IconButton(
                  icon: new Icon(Icons.check), onPressed: widget.onChecked)
            ],
          ))
        ]));
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
  }
}
