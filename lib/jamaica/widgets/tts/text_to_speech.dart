import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { PLAYING, PAUSE, STOPPED }

class FlutterTextToSpeech {
  GlobalKey<TextToSpeechState> textToSpeech;

  FlutterTextToSpeech() {
    textToSpeech = new GlobalKey<TextToSpeechState>();
  }
  Future<dynamic> speak() => textToSpeech.currentState.speak();

  Future<dynamic> pause() => textToSpeech.currentState.pause();
}

class TextToSpeech extends StatefulWidget {
  final FlutterTextToSpeech keys;
  final Function onComplete;
  final Function(String) onLongPress;
  final Function(TtsState) playingStatus;
  final TextStyle textStyle;
  final Color highlightColor;
  final String setLanguage;
  final String fullText;
  final double setSpeechRate;
  TextToSpeech({
    @required this.keys,
    this.onComplete,
    this.onLongPress,
    this.playingStatus,
    this.textStyle = const TextStyle(fontSize: 20, color: Colors.black54),
    this.highlightColor = Colors.red,
    this.setLanguage = 'EN-IN',
    @required this.fullText,
    this.setSpeechRate = .78,
  }) : super(key: keys.textToSpeech);
  @override
  TextToSpeechState createState() => new TextToSpeechState();
}

final regExp1 = RegExp('[\n]');
final regExp2 = RegExp('[!.,"-:|?–]');

class TextToSpeechState extends State<TextToSpeech> {
  bool isPlaying = false, isLoading = false;
  int version = 7, count = 0;
  List<String> listOfLines, words;
  FlutterTts flutterTts;
  String startText = '', middleText = '', endText = '';
  String content = '', temp = '', text = '';

  @override
  void initState() {
    super.initState();
    content = widget.fullText;
    text = content.replaceAll(regExp1, ' ');
    if (!text.substring(text.length - 1, text.length).contains(regExp2))
      text = text + '.';
    var words = text.split(" ");
    for (var i = 0; i < words.length; i++) {
      if (words[i].substring(0, 1).contains(regExp2)) {
        words.removeAt(i);
        break;
      }
    }
    temp = words.join(' ');
    endText = temp;
  }

  reset() {
    setState(() {
      startText = '';
      middleText = '';
      endText = temp;
      isLoading = true;
    });
  }

  getVersion() async {
    String platformVersion;
    try {
      // platformVersion = await GetVersion.platformVersion;
      // print(platformVersion.split(" "));
      // var s = platformVersion.split(" ")[1];
      // s = s.substring(0, 1);
      // version = int.parse(s).floor();
      print(version);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
  }

  stringFormat() async {
    initTts();
    words = List<String>();
    listOfLines = List<String>();
    text = widget.fullText.replaceAll(regExp1, ' ');
    if (!text.substring(text.length - 1, text.length).contains(regExp2)) {
      text = text + '.';
    }
    var string = '';
    words = text.split(" ");
    for (var i = 0; i < words.length; i++) {
      if (words[i].substring(0, 1).contains(regExp2)) {
        words.removeAt(i);
        break;
      }
    }
    temp = words.join(' ');
    for (var i = 0; i < words.length; i++) {
      string = string + words[i] + ' ';
      if (words[i].contains(RegExp('[.,|?]'))) {
        listOfLines.add(string);
        string = '';
      }
    }
  }

  Future initTts() async {
    flutterTts = FlutterTts();
    if (Platform.isAndroid) {
      flutterTts.setSpeechRate(widget.setSpeechRate);
      flutterTts.setLanguage(widget.setLanguage);
    }
    if (Platform.isAndroid) {
      flutterTts.ttsInitHandler(() {
        print('tts');
      });
    }
    flutterTts.completionHandler = () {
      if (count == listOfLines.length - 1) {
        setState(() {
          count = 0;
          startText = '';
          middleText = '';
          endText = temp;
          words = temp.split(" ");
        });
        widget.playingStatus(TtsState.PAUSE);
        widget.onComplete();
      } else {
        if (version < 8) {
          count++;
          speak();
        }
      }
      if (words.isEmpty) {
        setState(() {
          reset();
          endText = temp;
          words = temp.split(" ");
          widget.playingStatus(TtsState.PAUSE);
          widget.onComplete();
        });
      }
    };
    flutterTts.errorHandler = (e) {
      print(e);
    };
    // flutterTts.onRangeStart = (start, end) {
    //   if (version >= 8) highlightApi26(start, end);
    // };
  }

  highlight() {
    var s = '', e = '';
    setState(() {
      for (var i = 0; i < count; i++) s = s + listOfLines[i];
      startText = s;
      middleText = listOfLines[count];
      for (var i = count + 1; i < listOfLines.length; i++) {
        e = e + listOfLines[i];
      }
      endText = e;
    });
  }

  void highlightApi26(int start, int end) {
    setState(() {
      startText = startText + middleText;
      middleText = '';
      middleText = words.removeAt(0) + ' ';
      endText = '';
      endText = words.join(" ");
    });
  }

  Future<dynamic> pause() => flutterTts.stop().then((s) {
        if (s == 1) {
          if (widget.playingStatus != null)
            widget.playingStatus(TtsState.PAUSE);
        }
      });

  Future<dynamic> speak() async {
    if (count == 0 || listOfLines.isEmpty || words.isEmpty) {
      stringFormat();
      setState(() {});
    }
    initTts();
    final middle = version >= 8 ? words.join(' ') : listOfLines[count];
    if (widget.playingStatus != null) widget.playingStatus(TtsState.PLAYING);
    new Future.delayed(
        Duration(milliseconds: (count == 0 || listOfLines.isEmpty) ? 600 : 40),
        () {
      _speak(middle);
    });
  }

  _speak(String text) {
    flutterTts.speak(text).then((s) {
      if (s == 1) {
        if (version < 8) {
          highlight();
        } else {}
      }
    });
  }

  onComplete() => setState(() => count = 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _RichText(
        end: endText,
        middle: middleText,
        start: startText,
        highlightColor: widget.highlightColor,
        onLongPress: (s) => widget.onLongPress(s),
        textStyle: widget.textStyle,
      ),
    );
    // return _buildText();
  }

  @override
  void dispose() {
    flutterTts?.stop();
    super.dispose();
  }

  @override
  void deactivate() {
    flutterTts?.stop();
    super.deactivate();
  }
}

class _RichText extends StatelessWidget {
  final String start;
  final String middle;
  final String end;
  final Color highlightColor;
  final Function(String) onLongPress;
  final TextStyle textStyle;
  _RichText(
      {Key key,
      this.start,
      this.middle,
      this.end,
      this.onLongPress,
      this.textStyle,
      this.highlightColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var index = 0;
    var space = ' ';
    var newLine = '';
    final children = <TextSpan>[];
    if (start != '')
      start.split(" ").map((s) {
        index++;
        if (index == start.split(" ").length) space = '';
        if (s.contains(RegExp('[.]'))) {
          newLine = '\n';
        } else {
          newLine = '';
        }
        children.add(TextSpan(
            text: s + space + newLine,
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () => onLongPress(s)));
      }).toList();
    space = ' ';
    index = 0;
    if (middle != '')
      middle.split(" ").map((s) {
        index++;
        if (index == middle.split(" ").length) space = '';
        if (s.contains(RegExp('[.]'))) {
          newLine = '\n';
        } else {
          newLine = '';
        }
        children.add(TextSpan(
            text: s + space + newLine,
            style: TextStyle(color: highlightColor),
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () => onLongPress(s)));
      }).toList();
    space = ' ';
    index = 0;
    if (end != '')
      end.split(" ").map((s) {
        index++;
        if (index == end.split(" ").length) space = '';
        if (s.contains(RegExp('[.]'))) {
          newLine = '\n';
        } else {
          newLine = '';
        }
        children.add(TextSpan(
            text: s + space + newLine,
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () => onLongPress(s)));
      }).toList();
    space = ' ';
    index = 0;
    return RepaintBoundary(
        child: RichText(text: TextSpan(children: children, style: textStyle)));
  }
}

Map<int, int> get sdkIntValue {
  return {5: 21, 6: 23, 7: 25, 8: 26, 9: 28};
}
