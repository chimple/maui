import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/text_audio.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnError(Exception exception);

const kUrl = "http://www.rxlabz.com/labz/audio2.mp3";
const kUrl2 = "http://www.rxlabz.com/labz/audio.mp3";

enum PlayerState { stopped, playing, paused }

class AudioTextBold extends StatefulWidget {
  final QuackCard card;

  AudioTextBold({this.card});

  @override
  AudioTextBoldState createState() => new AudioTextBoldState();
}

class AudioTextBoldState extends State<AudioTextBold> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;
  // String firsttext =
  //     "Siku moja Sungura alimtembelea Jimbi na familia yake usiku. Walifurahia kula chajio pamoja.";

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  int get durationText => duration != null ? duration.inMilliseconds : '';
  int get positionText => position != null ? position.inMilliseconds : '';

  // bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  // Future play() async {
  //   await audioPlayer.play(kUrl);
  //   setState(() {
  //     playerState = PlayerState.playing;
  //   });
  // }

  Future playaudio(String fileName) async {
    try {
      final file =
          new File(AppStateContainer.of(context).extStorageDir + fileName);
      if (await file.exists()) {
        await audioPlayer.play(file.path, isLocal: true);
        setState(() {
          playerState = PlayerState.playing;
        });
      } else {
        // await file.writeAsBytes(
        //     (await rootBundle.load('assets/$fileName')).buffer.asUint8List());
        // await audioPlayer.play(file.path, isLocal: true);
      }
    } catch (e) {
      print('Failed playing $fileName: $e');
    }
  }

  Future _playLocal() async {
    await audioPlayer.play(localFilePath, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  // Future _loadFile() async {
  //   final dir = await getExternalStorageDirectory();
  //   final file = new File('${dir.path}/2.m4a');

  //   // await file.writeAsBytes(bytes);
  //   if (await file.exists())
  //     setState(() {
  //       localFilePath = file.path;
  //     });
  //   _playLocal();
  // }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    widget.card.contentAudio != null
                        ? new IconButton(
                            onPressed: () =>
                                playaudio(widget.card.contentAudio),
                            icon: Icon(
                              Icons.play_circle_filled,
                              color: Colors.red,
                              size: 50,
                            ),
                          )
                        : Container(),
                  ]),
            ),
            widget.card.title == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    child: Text(
                      widget.card.title ?? '',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: !isPlaying
                  ? Text(widget.card.content ?? '',
                      style: Theme.of(context).textTheme.display1)
                  : TextAudio(
                      audiofile: widget.card.contentAudio,
                      fulltext: widget.card.content ?? '',
                      duration: durationText,
                    ),
            )
          ]),
    );
  }
}
