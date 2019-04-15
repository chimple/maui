import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/story/activity/drag_text.dart';
// import 'package:maui/jamaica/widgets/story/activity/jumble_words.dart';
import 'package:maui/jamaica/widgets/story/play_pause_button.dart';
// import 'package:maui/jamaica/widgets/story/router.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';
import 'package:maui/jamaica/widgets/story/activity/text_highlighter.dart';

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
  final String pageNumber;
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
      this.index,
      this.pageNumber})
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
  @override
  void initState() {
    super.initState();
    print('initState');
  }

  @override
  void dispose() {
    audioCache?.clearCache();
    audioPlayer?.stop();
    super.dispose();
  }

  Future pause() async {
    print('pause');
    await audioPlayer.pause().then((s) {
      setState(() => isPause = true);
      _duration = 0;
      isDurationZero = false;
    });
    widget.pageSliding(widget.index);
  }

  Future resume() async {
    // reset();
    await audioPlayer.release();
    play(_audioFiles[incr]).then((s) {
      setState(() {
        isPause = false;
      });
    });
    print('audio status ${audioPlayer.state}');
    widget.pageSliding(widget.index);
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
    print('completed ${widget.pageNumber}');
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

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Column(
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        // border: Border.all(width: 2.0, color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'assets/stories/images/${widget.imagePath}'),
                        )),
                  )),
              Expanded(
                flex: 1,
                child: PlayPauseButton(
                  audioPlayer: audioPlayer,
                  isPause: isPause,
                  isPlaying: isPlaying,
                  loadAudio: () => loadAudio(widget.fullText, widget.audioFile),
                  pause: () => pause(),
                  resume: () => resume(),
                ),
              ),
              Expanded(flex: 7, child: Container(child: _buildText()))
            ],
          )
        : Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 6, child: _buildImage()),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: SingleChildScrollView(
                                controller: ScrollController(),
                                child: _buildText()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: (storyMode != StoryMode.textHighlighterMode)
                        ? PlayPauseButton(
                            audioPlayer: audioPlayer,
                            isPause: isPause,
                            isPlaying: isPlaying,
                            loadAudio: () =>
                                loadAudio(widget.fullText, widget.audioFile),
                            pause: () => pause(),
                            resume: () => resume(),
                          )
                        : Container(),
                  ),
                  Expanded(flex: 3, child: Container())
                ],
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.cyanAccent,
              //   maxRadius: 25,
              //   child: IconButton(
              //       icon: Icon(
              //         (storyMode == StoryMode.textHighlighterMode ||
              //                 storyMode == StoryMode.dragTextMode)
              //             ? Icons.close
              //             : Icons.navigate_next,
              //         color: Colors.blue,
              //         size: 25,
              //       ),
              //       onPressed: () {
              //         if (storyMode == StoryMode.showDialogOnLongPressMode) {
              //           setState(() => storyMode = StoryMode.textHighlighterMode);
              //         } else if (storyMode == StoryMode.textHighlighterMode ||
              //             storyMode == StoryMode.dragTextMode) {
              //           setState(
              //               () => storyMode = StoryMode.showDialogOnLongPressMode);
              //         }
              //       }),
              // ),
            ],
          );
  }

  Widget _buildText() {
    print('storymode: ${storyMode}');
    if (storyMode == StoryMode.textMode)
      return TextMode(
        text: widget.fullText,
      );
    else if (storyMode == StoryMode.audioBoldTextMode) {
      return RichText(
        text: new TextSpan(
          children: <TextSpan>[
            new TextSpan(text: startLine, style: textStyle),
            new TextSpan(text: start, style: textStyle),
            new TextSpan(text: middle, style: highlightTextStyle),
            new TextSpan(text: end, style: textStyle),
            new TextSpan(text: endLine, style: textStyle),
          ],
        ),
      );
    } else if (storyMode == StoryMode.textHighlighterMode)
      return TextHighlighter(
          text: widget.fullText,
          onComplete: (l) {
            new Future.delayed(Duration(seconds: 1), () {
              setState(() {
                storyMode = StoryMode.dragTextMode;
              });
            });

            print(l);
          });
    else if (storyMode == StoryMode.showDialogOnLongPressMode)
      return ShowDialogMode(listofWords: widget.fullText.split(' '));
    else if (storyMode == StoryMode.dragTextMode)
      return DragText(data: widget.imageItemsAnswer);
    else {
      return Container();
    }
  }

  Widget _buildImage() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(width: 2.0, color: Colors.orange),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/stories/images/${widget.imagePath}'))),
            )),
        storyMode == StoryMode.textHighlighterMode
            ? Text('Where georgie Porgie went in the  afternoon',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ))
            : Container()
      ],
    );
  }
}

class TextMode extends StatelessWidget {
  final String text;
  TextMode({this.text});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(text: text, style: textStyle),
    );
  }
}
