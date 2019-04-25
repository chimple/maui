import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:maui/jamaica/widgets/story/audio_text_bold.dart';
import 'package:maui/jamaica/widgets/story/play_pause_button.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';

class TtsLineByLine extends StatefulWidget {
  final String fullText;
  final String imagePath;
  final Function pageSliding;
  final int index;
  TtsLineByLine(
      {Key key,
      this.fullText = "Text to speach line by line",
      @required this.imagePath,
      this.pageSliding,
      this.index})
      : super(key: key);
  @override
  _TextAudioState createState() => new _TextAudioState();
}

class _TextAudioState extends State<TtsLineByLine> {
  bool isPlaying = false, isPause = true;
  List<String> listOfLines = [];

  FlutterTts flutterTts;
  String text;
  List<int> colorStatus;
  int startIndex = 0, endIndex = 0, incr = 0;
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    colorStatus = List(widget.fullText.split(" ").length);
    text = widget.fullText.replaceAll(RegExp(r'[\n]'), ' ');
    setZero();
    initTts();
  }

  initTts() {
    listOfLines.addAll(text.split(RegExp('[!.]')));
    flutterTts.startHandler = () {
      int end = 0, start = 0;
      for (int i = 0; i < incr; i++) {
        start = listOfLines[i].split(" ").length;
      }
      for (int i = 0; i <= incr; i++) {
        end = end + listOfLines[i].split(" ").length;
      }
      startIndex = start;
      endIndex = end;
      setZero();
      for (int i = startIndex; i < endIndex; i++) {
        colorStatus[i] = 1;
      }
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    };
    flutterTts.completionHandler = () {
      print('complete');
      if (incr == listOfLines.length - 1) {
        setState(() {
          isPlaying = false;
          isPause = true;
          endIndex = 0;
          startIndex = 0;
          incr = 0;
          setZero();
          widget.pageSliding(false);
        });
      } else {
        incr++;
        speak();
      }
    };
  }

  setZero() {
    for (int i = 0; i < text.split(" ").length; i++) {
      colorStatus[i] = 0;
    }
    setState(() {});
  }

  Future pause() async {
    print('pause');
    await flutterTts.stop().then((s) {
      if (s == 1) {
        setState(() => isPause = true);
        widget.pageSliding(false);
      }
    });
  }

  speak() async {
    print('speak');
    await flutterTts.speak(listOfLines[incr]).then((s) {
      if (s == 1) {
        setState(() {
          isPause = false;
          colorIndex = -1;
          widget.pageSliding(true);
        });
      }
    });
  }

  void onComplete() {
    setState(() {
      isPlaying = false;
      isPause = true;
      incr = 0;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    print('line by line');
    if (text != null && widget.imagePath != null)
      return Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildImage()),
          Expanded(flex: 4, child: _buildText()),
          Expanded(
            flex: 1,
            child: PlayPauseButton(
              textToSpeachType: TextToSpeachType.tts,
              isPause: isPause,
              loadAudio: () {},
              pause: () => pause(),
              resume: () {},
              speak: () => speak(),
            ),
          ),
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
              isPause: isPause,
              isPlaying: isPlaying,
              loadAudio: () {},
              pause: () => pause(),
              speak: () => speak(),
            ),
          )
        ],
      );
  }

  int colorIndex = -1;
  Widget _text(String s, int index) {
    return InkWell(
      onLongPress: () {
        if (isPause) {
          setState(() {
            colorIndex = index;
          });
          showDialog(
            context: context,
            builder: (context) {
              return FractionallySizedBox(
                  heightFactor:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 0.5
                          : 0.8,
                  widthFactor:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 0.8
                          : 0.4,
                  child: ShowDialogModeState()
                      .textDescriptionDialog(context, s, 'textDesciption'));
            },
          );
        }
      },
      child: Text(s + ' ',
          style: TextStyle(
              fontSize: 23,
              color: colorStatus[index] == 1 ? Colors.red : Colors.black54,
              background: Paint()
                ..color =
                    (colorIndex == index) ? Colors.red : Colors.transparent)),
    );
  }

  Widget _buildText() {
    int index = 0;
    return Wrap(
      children: text.split(" ").map((s) {
        return _text(s, index++);
      }).toList(),
    );
  }
}
