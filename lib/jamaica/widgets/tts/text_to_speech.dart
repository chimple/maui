import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  final Function onComplete;
  final String fullText;
  final TextStyle textStyle;
  final Color highLightColor;
  final Function(String) onTap;
  final Function(String) onLongPress;
  final double setSpeechRate;
  final Function(TtsState) playingStatus;
  final String setLanguage;
  final int index;
  final FlutterTextToSpeech keys;
  TextToSpeech(
      {@required this.keys,
      this.playingStatus,
      @required this.fullText,
      this.setSpeechRate = .78,
      this.setLanguage='EN-IN',
      this.index,
      this.onTap,
      this.onLongPress,
      this.onComplete,
      this.highLightColor = Colors.red,
      this.textStyle = const TextStyle(fontSize: 20, color: Colors.black54)})
      : super(key: keys.textToSpeech) {}
  @override
  TextToSpeechState createState() => new TextToSpeechState();
}

final regExp1 = RegExp('[\n]');
final regExp2 = RegExp('[!.,"-:|?–]');

class TextToSpeechState extends State<TextToSpeech> {
  bool isPlaying = false;
  List<String> listOfLines;
  int incr = 0;
  bool isLoading = false;
  FlutterTts flutterTts;
  String text;
  String startText = '', middleText = '', endText = '';
  int version = 7;
  List<String> words;
  String temp = '';
  Key keys;
  String _content;

  @override
  void initState() {
    super.initState();
    _content = widget.fullText;
    text = _content.replaceAll(regExp1, ' ');
    if (!text.substring(text.length - 1, text.length).contains(regExp2)) {
      text = text + '.';
    }
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
      if (incr == listOfLines.length - 1) {
        setState(() {
          incr = 0;
          startText = '';
          middleText = '';
          endText = temp;
          words = temp.split(" ");
        });
        widget.playingStatus(TtsState.PAUSE);
        widget.onComplete();
      } else {
        if (version < 8) {
          incr++;
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
      for (var i = 0; i < incr; i++) s = s + listOfLines[i];
      startText = s;
      middleText = listOfLines[incr];
      for (var i = incr + 1; i < listOfLines.length; i++) {
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
    if (incr == 0 || listOfLines.isEmpty) {
      stringFormat();
      setState(() {});
    }
    initTts();
    final middle = version >= 8 ? words.join(' ') : listOfLines[incr];
    if (widget.playingStatus != null) widget.playingStatus(TtsState.PLAYING);
    new Future.delayed(
        Duration(milliseconds: (incr == 0 || listOfLines.isEmpty) ? 600 : 40),
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

  onComplete() => setState(() {
        incr = 0;
      });

  @override
  Widget build(BuildContext context) {
    var index = 0;
    var space = ' ';
    final children = <Widget>[];
    Widget _text(String data, String space) {
      return InkWell(
        onTap: widget.onTap != null ? () => widget.onTap(data) : null,
        onLongPress:
            widget.onLongPress != null ? () => widget.onLongPress(data) : null,
        child: Text(data + space, style: widget.textStyle),
      );
    }

    if (startText != '')
      startText.split(" ").map((s) {
        index++;
        if (index == startText.split(" ").length) space = '';
        children.add(_text(s, space));
      }).toList();
    space = ' ';
    index = 0;
    if (middleText != '')
      middleText.split(" ").map((s) {
        index++;
        if (index == middleText.split(" ").length) space = '';
        children.add(InkWell(
          onTap: widget.onTap != null ? () => widget.onTap(s) : null,
          onLongPress:
              widget.onLongPress != null ? () => widget.onLongPress(s) : null,
          child: Text(
            s + space,
            style: TextStyle(
                background: widget.textStyle.background,
                backgroundColor: widget.textStyle.backgroundColor,
                fontFamily: widget.textStyle.fontFamily,
                decoration: widget.textStyle.decoration,
                fontSize: widget.textStyle.fontSize,
                color: widget.highLightColor),
          ),
        ));
      }).toList();
    space = ' ';
    index = 0;
    if (endText != '')
      endText.split(" ").map((s) {
        index++;
        if (index == endText.split(" ").length) space = '';
        children.add(_text(s, space));
      }).toList();
    space = ' ';
    index = 0;
    Widget _buildText() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: children,
        ),
      );
    }

    return _buildText();
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

Map<int, int> get sdkIntValue {
  return {5: 21, 6: 23, 7: 25, 8: 26, 9: 28};
}
