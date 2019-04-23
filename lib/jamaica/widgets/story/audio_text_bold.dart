import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:maui/jamaica/widgets/story/activity/drag_text.dart';
import 'package:maui/jamaica/widgets/story/custom_editable_text.dart';
// import 'package:maui/jamaica/widgets/story/activity/jumble_words.dart';
import 'package:maui/jamaica/widgets/story/play_pause_button.dart';
// import 'package:maui/jamaica/widgets/story/router.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';
import 'package:maui/jamaica/widgets/story/activity/text_highlighter.dart';

enum TextToSpeachType { fromAudio, fromTts, hear2Read }
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
  final Function(int, StoryMode) storyModeCallback;
  final VoidCallback onComplete;
  final String audioFile;
  final StoryMode storyMode;
  final String imagePath;
  final imageItemsPosition;
  final BuiltList<String> imageItemsAnswer;
  final int index;
  AudioTextBold(
      {Key key,
      this.storyMode,
      this.imageItemsPosition,
      this.onComplete,
      @required this.fullText,
      this.pageSliding,
      @required this.audioFile,
      @required this.imagePath,
      this.storyModeCallback,
      this.imageItemsAnswer,
      this.index})
      : super(key: key);
  @override
  _TextAudioState createState() => new _TextAudioState();
}

class _TextAudioState extends State<AudioTextBold> {
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
  StoryMode storyMode = StoryMode.textMode;
  List<StoryMode> listStoryMode = [];
  ScrollController _scrollController = new ScrollController();
  FlutterTts flutterTts;
  TextToSpeachType textToSpeachType;
  String text;
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    print('initState');
    text = widget.fullText.replaceAll(RegExp(r'[\n]'), ' ');
  }

  @override
  void dispose() {
    audioCache?.clearCache();
    audioPlayer?.stop();
    flutterTts.stop();
    super.dispose();
  }

  Future pause() async {
    print('pause');
    if (textToSpeachType == TextToSpeachType.fromAudio) {
      await audioPlayer.pause().then((s) {
        setState(() => isPause = true);
        _duration = 0;
        isDurationZero = false;
      });
      widget.pageSliding(widget.index);
    } else if (textToSpeachType == TextToSpeachType.hear2Read) {
    } else {}
  }

  Future resume() async {
    // reset();
    if (textToSpeachType == TextToSpeachType.fromAudio) {
      await audioPlayer.release();
      play(_audioFiles[incr]).then((s) {
        setState(() {
          isPause = false;
        });
      });
      print('audio status ${audioPlayer.state}');
      widget.pageSliding(widget.index);
    } else if (textToSpeachType == TextToSpeachType.hear2Read) {
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
          storyMode = StoryMode.audioBoldTextMode;
          isDurationZero = true;
        }
      };
      if (isPlaying) {
        playNext();
      }
    } catch (e) {}
  }

  speak(String text) {
    flutterTts.speak(text);
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
    if (audio != null) {
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
            textToSpeachType = TextToSpeachType.fromAudio;
          });
          widget.pageSliding(widget.index);
          if (storyMode == StoryMode.audioBoldTextMode) {}
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
      widget.pageSliding(widget.index);
      listOfLines.addAll(text.split(RegExp('[!.]')));
      print(listOfLines);
      speak(listOfLines.removeAt(0));
      flutterTts.startHandler = () {
        setState(() {
          isPlaying = true;
          isPause = false;
          textToSpeachType = TextToSpeachType.hear2Read;
        });
      };
      flutterTts.completionHandler = () {
        if (listOfLines.isEmpty) {
          print('true');
          setState(() {
            isPlaying = false;
            isPause = true;
            widget.pageSliding(widget.index);
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
      storyMode = StoryMode.showDialogOnLongPressMode;
    });
    widget.pageSliding(widget.index);
    widget.onComplete();
  }

  String _startSubString = '', _middleSubString = '', _endSubString = '';
  @override
  Widget build(BuildContext context) {
    print(text);
    if (text != null && widget.imagePath != null)
      return Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildImage()),
          Expanded(
            flex: 1,
            child: PlayPauseButton(
              audioPlayer: audioPlayer,
              isPause: isPause,
              isPlaying: isPlaying,
              loadAudio: () => loadAudio(text, widget.audioFile),
              pause: () => pause(),
              resume: () => resume(),
            ),
          ),
          Expanded(flex: 4, child: _buildText())
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
            child: _buildText(),
          ),
          Expanded(
            flex: 1,
            child: PlayPauseButton(
              audioPlayer: audioPlayer,
              isPause: isPause,
              isPlaying: isPlaying,
              loadAudio: () => loadAudio(text, widget.audioFile),
              pause: () => pause(),
              resume: () => resume(),
            ),
          )
        ],
      );
  }

  Widget _buildImage() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          // border: Border.all(width: 2.0, color: Colors.white),
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('${widget.imagePath}'),
          )),
    );
  }

  Widget _buildText() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: _startSubString,
                      style:
                          TextStyle(fontSize: 23, color: Colors.transparent)),
                  TextSpan(
                      text: _middleSubString,
                      style: TextStyle(
                          fontSize: 23,
                          background: Paint()..color = Colors.red,
                          color: Colors.transparent)),
                  TextSpan(
                      text: _endSubString,
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 23,
                      ))
                ],
              ),
            ),
            CustomEditableText(
                controller: CustomTextEditingController(text: text),
                focusNode: FocusNode(),
                cursorColor: Colors.transparent,
                style: TextStyle(color: Colors.black54, fontSize: 23),
                backgroundCursorColor: Colors.transparent,
                maxLines: null,
                dragStartBehavior: DragStartBehavior.start,
                startOffset: (s) => {},
                updateOffset: (o) => {},
                draEnd: (t) {},
                onLongPress: (s, textSelection) {
                  if (s != ' ' && s != '' && s != '\n') {
                    print('show');
                    setState(() {
                      _middleSubString = text.substring(
                          textSelection.baseOffset, textSelection.extentOffset);
                      _startSubString =
                          text.substring(0, textSelection.baseOffset);
                      _endSubString = text.substring(
                          textSelection.extentOffset, text.length);
                    });
                    showDialog(
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
                            child: ShowDialogModeState().textDescriptionDialog(
                                context, s, 'textDesciption'));
                      },
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
