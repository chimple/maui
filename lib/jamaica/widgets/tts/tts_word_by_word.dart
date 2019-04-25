import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:maui/jamaica/widgets/story/audio_text_bold.dart';
import 'package:maui/jamaica/widgets/story/play_pause_button.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';

class TtsWordByWord extends StatefulWidget {
  final String text;
  final bool speak;
  final bool pasue;
  final String imagePath;
  final Function pageSliding;
  TtsWordByWord(
      {Key key,
      this.pasue,
      this.imagePath,
      this.pageSliding,
      this.speak,
      this.text = "Text to speach word by word"})
      : super(key: key);
  @override
  _TextSpeakWordsByWordsState createState() =>
      new _TextSpeakWordsByWordsState();
}

class _TextSpeakWordsByWordsState extends State<TtsWordByWord> {
  String text;
  bool isPlaying = false, isPause = true;
  List<String> listOfLines = [];
  FlutterTts flutterTts;
  List<int> colorStatus;
  int startIndex = 0, endIndex = 0, colorIndex = 0, colorIndex1 = -1;
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setSpeechRate(.78);
    init();
  }

  void init() {
    flutterTts.startHandler = () {};
    flutterTts.completionHandler = () {
      setState(() {
        isPause = true;
        colorIndex = 0;
        colorIndex1 = -1;
      });
    };
    // flutterTts.ttsOnRangeStart((e) {
    //   highlight();
    // });
    flutterTts.errorHandler = (e) {
      print(e);
    };
  }

  highlight() {
    setState(() {});
    colorIndex++;
  }

  pause() {
    flutterTts.stop().then((s) {
      if (s == 1) {
        isPause = true;
        setState(() {});
      }
    });
  }

  speak() {
    String s =
        text.split(" ").getRange(colorIndex, text.split(" ").length).join(" ");
    flutterTts.speak(s).then((s) {
      if (s == 1) {
        isPause = false;
        colorIndex1 = -1;
        setState(() {});
      }
    });
  }

  @override
  dispose() {
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
              textToSpeachType: TextToSpeachType.tts,
              isPause: isPause,
              loadAudio: () {},
              pause: () => pause(),
              resume: () {},
              speak: () => speak(),
            ),
          )
        ],
      );
  }

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
            color: (colorIndex - 1 == index || colorIndex1 == index)
                ? Colors.red
                : Colors.black54,
          )),
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
