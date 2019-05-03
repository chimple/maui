import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:maui/jamaica/widgets/story/play_pause_button.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';
import 'package:maui/jamaica/widgets/tts/text_to_speech.dart';

enum TextToSpeechType {
  audio,
  tts,
  hear2Read,
}
final TextStyle textStyle = TextStyle(
  color: Colors.black,
  fontSize: 23,
  wordSpacing: 2.0,
);
final TextStyle highlightTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 23,
  wordSpacing: 2.0,
);

class AudioTextBold extends StatefulWidget {
  final String fullText;
  final Function pageSliding;
  final VoidCallback onComplete;
  final String audioFile;
  final String imagePath;
  final Function(String) onLongPress;
  final FlutterTextToSpeech keys;
  final Function(TtsState) playingStatus;
  AudioTextBold(
      {this.keys,
      this.onLongPress,
      this.playingStatus,
      this.onComplete,
      @required this.fullText,
      this.pageSliding,
      @required this.audioFile,
      @required this.imagePath});
  @override
  _AudioTextBold createState() => new _AudioTextBold();
}

class _AudioTextBold extends State<AudioTextBold> {
  int duration;
  set _duration(int d) => duration = d;
  int get durationText => duration != null ? duration : 0;
  static AudioPlayer audioPlayer = new AudioPlayer();
  final AudioCache audioCache =
      new AudioCache(prefix: 'stories/story_audio/', fixedPlayer: audioPlayer);
  bool isPlaying = false,
      isDurationZero = false,
      boldTextComplete = false,
      isPause = true,
      isAudioFileAvailableOrNot = false;
  String start = "", middle = "", end = "", endLine = '', startLine = '';
  List<String> _audioFiles = [], listOfLines = [], words;
  final _regex = RegExp('[a-zA-Z0-9]');
  final _regex1 = RegExp('[!?,|]');
  int numOfChar, charTime, incr = 0, _count;
  List<String> temp = [];
  ScrollController _scrollController = new ScrollController();
  FlutterTts flutterTts;
  TextToSpeechType textToSpeachType;
  String text;
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    text = widget.fullText; //.replaceAll(RegExp(r'[\n]'), ' ');
  }

  @override
  void dispose() {
    audioCache?.clearCache();
    audioPlayer?.stop();
    super.dispose();
  }

  Future pause() async {
    print('pause');
    if (textToSpeachType == TextToSpeechType.audio) {
      await audioPlayer.pause().then((s) {
        setState(() => isPause = true);
        _duration = 0;
        isDurationZero = false;
      });
    } else if (textToSpeachType == TextToSpeechType.hear2Read) {
    } else {}
  }

  Future resume() async {
    // reset();
    if (textToSpeachType == TextToSpeechType.audio) {
      await audioPlayer.release();
      play(_audioFiles[incr]).then((s) {
        setState(() {
          isPause = false;
        });
      });
      print('audio status ${audioPlayer.state}');
    } else if (textToSpeachType == TextToSpeechType.hear2Read) {
    } else {}
  }

  void reset() {
    startLine = '';
    for (int i = 0; i < incr; i++) {
      startLine = startLine + listOfLines[i];
    }
    endLine = '';
    for (int i = incr + 1; i < listOfLines.length; i++) {
      endLine = endLine + listOfLines[i];
    }
    setState(() {});
  }

  play(String url) async {
    print('play');
    try {
      await audioCache.play('$url');
      audioPlayer.durationHandler = (d) {
        _duration = d.inMilliseconds;
        if (durationText > 0 && !isDurationZero) {
          reset();
          looper(listOfLines[incr], durationText);
          isDurationZero = true;
        }
      };
      if (isPlaying) {
        playNext();
      }
    } catch (e) {}
  }

  playNext() async {
    audioPlayer.audioPlayerStateChangeHandler = (state) {
      if (state == AudioPlayerState.COMPLETED) {
        isDurationZero = false;
        incr++;
        // lastString = listOfLines[incr];
        print(incr);
        if (incr == _audioFiles.length) {
          new Future.delayed(Duration(milliseconds: 900), () {
            onComplete();
          });
        }

        lastAudioFile = _audioFiles[incr];
        _duration = 0;
        isDurationZero = false;
        if (incr != _audioFiles.length)
          new Future.delayed(Duration(milliseconds: 300), () {
            try {
              if (!isPause && mounted) play(_audioFiles[incr]);
            } catch (e) {
              print(e);
            }
          });
      }
    };
  }

  String lastString, lastAudioFile;
  void looper(String text, int time) async {
    print(text);
    List<String> listOfWords = [];
    lastString = text;
    listOfWords = text.split(" ");
    numOfChar = text.length;
    charTime = (time ~/ numOfChar);
    looping(listOfWords, listOfWords.length);
  }

  void looping(List<String> w, int l) async {
    String space = " ";
    start = '';
    middle = '';
    end = '';
    for (int i = 0; i < l - 1; i++) {
      if (mounted && !isPause)
        setState(() {
          start = start + middle;
          try {
            if (i == l - 1) space = '';
            middle = w.removeAt(0) + space;
          } catch (c) {}
          end = "";
          end = w.join(" ");
        });
      await Future.delayed(
          Duration(milliseconds: (isPause) ? 0 : middle.length * charTime));
      if (audioPlayer.state == AudioPlayerState.PAUSED) break;
    }
  }

  int checkSpecialChar(String middle) {
    int time = middle.length * charTime;
    String s = middle.substring(0, 1);
    if (mounted) {
      bool c = s.contains(_regex);
      if (!c) time = 0;
    }
    return time;
  }

  Future loadAudio(String text, String audio) async {
    String string = '';
    words = text.split(" ");
    listOfLines?.clear();
    _audioFiles?.clear();
    for (int i = 0; i < words.length; i++) {
      string = string + words[i] + ' ';
      if (words[i].contains(RegExp('[!.]'))) {
        listOfLines.add(string);
        string = '';
      }
    }

    // for (int i = 0; i < listOfLines.length; i++)
    //   listOfLines[i] = listOfLines[i] + ".";
    String str;
    _count = '.'.allMatches(text).length + '!'.allMatches(text).length;
    // bool b = words[words.length - 1].contains(_regex1);
    // print(_count);
    // if (b) _count = _count + 1;
    for (int i = 1; i <= _count; i++) {
      str = audio + i.toString();
      _audioFiles.add('$str.m4a');
    }

      try {
        await audioCache.loadAll(_audioFiles).then((s) {
          lastAudioFile = _audioFiles[0];
          play(_audioFiles[0]);
          setState(() {
            isPlaying = true;
            isPause = false;
            isAudioFileAvailableOrNot = false;
            textToSpeachType = TextToSpeechType.audio;
          });
        }, onError: (e) {
          setState(() {
            isPlaying = false;
            isPause = true;
            isAudioFileAvailableOrNot = true;
          });
          showSnackbar(e.toString());
        });
      } catch (e) {
        print(e);
      }
    } else {
      listOfLines.addAll(text.split(RegExp('[!.]')));
      print(listOfLines);
      speak(listOfLines.removeAt(0));
      flutterTts.startHandler = () {
        setState(() {
          isPlaying = true;
          isPause = false;
          textToSpeachType = TextToSpeechType.hear2Read;
        });
      };
      flutterTts.completionHandler = () {
        if (listOfLines.isEmpty) {
          print('true');
          setState(() {
            isPlaying = false;
            isPause = true;
          });
        } else
          speak(listOfLines?.removeAt(0));
      };
    }
  }

  showSnackbar(String s) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Container(height: 20, child: Center(child: Text(s))),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
      duration: Duration(seconds: 1),
    ));
  }

  void onComplete() {
    setState(() {
      isPlaying = false;
      isPause = true;
      start = "";
      middle = "";
      end = "";
      boldTextComplete = true;
      incr = 0;
      duration = 0;
      isDurationZero = false;
      endLine = '';
    });
    widget.onComplete();
  }

  TtsState ttsState = TtsState.PAUSE;
  @override
  Widget build(BuildContext context) {
    if (text != null && widget.imagePath != null)
      return Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildImage()),
          Expanded(
              flex: 4,
              child: TextToSpeech(
                playingStatus: (s) {
                  setState(() {
                    ttsState = s;
                  });
                  widget.playingStatus(s);
                },
                onComplete: () => widget.onComplete(),
                fullText: widget.fullText,
                keys: widget.keys,
                onLongPress: (ttsState == TtsState.PAUSE)
                    ? (s) async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return FractionallySizedBox(
                                heightFactor:
                                    MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? 0.5
                                        : 0.8,
                                widthFactor:
                                    MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? 0.8
                                        : 0.4,
                                child: textDescriptionDialog(
                                    context, s, 'textDesciption'));
                          },
                        );
                      }
                    : null,
              ))
        ],
      );
    else if (text == '') {
      return Column(
        children: <Widget>[
          Expanded(child: _buildImage()),
        ],
      );
    } else
      return Column(
        children: <Widget>[
          Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextToSpeech(
                  playingStatus: (status) => widget.playingStatus(status),
                  onComplete: () => widget.onComplete(),
                  fullText: widget.fullText,
                  keys: widget.keys,
                  onLongPress: (s) async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return FractionallySizedBox(
                            heightFactor: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 0.5
                                : 0.8,
                            widthFactor: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 0.8
                                : 0.4,
                            child: textDescriptionDialog(
                                context, s, 'textDesciption'));
                      },
                    );
                  },
                ),
              )),
        ],
      );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('${widget.imagePath}'),
        )),
      ),
    );
  }

  int colorIndex = -1;
}

Widget textDescriptionDialog(
    BuildContext context, String text, String textDesciption) {
  text = text.replaceAll(new RegExp(r'[^\w\s]+'), '');
  MediaQueryData mediaQuery = MediaQuery.of(context);
  return new Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
    ),
    child: Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.close),
                  iconSize: mediaQuery.size.height * 0.07,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              new IconButton(
                  icon: new Icon(Icons.volume_up),
                  iconSize: mediaQuery.size.height * 0.07,
                  color: Colors.black,
                  onPressed: () {
                    FlutterTts().speak(text);
                  }),
            ],
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: mediaQuery.size.height * 0.05, color: Colors.green),
          ),
          Image.asset('assets/stories/images/$text.jpg',
              height: mediaQuery.orientation == Orientation.portrait
                  ? mediaQuery.size.height * 0.2
                  : mediaQuery.size.height * 0.3),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              textDesciption + '$text',
              style: TextStyle(
                  fontSize: mediaQuery.orientation == Orientation.portrait
                      ? mediaQuery.size.height * 0.02
                      : mediaQuery.size.height * 0.03,
                  color: Colors.black),
            ),
          )
        ],
      ),
    ),
  );
}
