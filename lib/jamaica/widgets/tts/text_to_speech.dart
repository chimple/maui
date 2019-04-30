import 'dart:async';
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
  final Function(String) onDoubleTap;
  final double setSpeechRate;
  final Function(TtsState) playingStatus;
  final int index;
  final FlutterTextToSpeech keys;
  TextToSpeech(
      {@required this.keys,
      this.playingStatus,
      @required this.fullText,
      this.onDoubleTap,
      this.setSpeechRate = .78,
      this.index,
      this.onTap,
      this.onLongPress,
      this.onComplete,
      this.highLightColor = Colors.red,
      this.textStyle = const TextStyle(fontSize: 20, color: Colors.black54)})
      : assert(fullText != null),
        super(key: keys.textToSpeech);
  @override
  TextToSpeechState createState() => new TextToSpeechState();
}

class TextToSpeechState extends State<TextToSpeech>
    with AutomaticKeepAliveClientMixin<TextToSpeech> {
  bool isPlaying = false;
  List<String> listOfLines = [];
  int incr = 0;
  bool isLoading = false;
  FlutterTts flutterTts;
  String text;
  String startText = '', middleText = '', endText = '';
  int version = 7;
  List<String> words;
  final regExp1 = RegExp('[\n]');
  final regExp2 = RegExp('[!.,"-:|?–]');
  String temp = '';
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setSpeechRate(widget.setSpeechRate);
    stringFormat();
    initTts();
    getVersion();
    reset();
    // WidgetsBinding.instance.addPostFrameCallback((_) => reset());
  }

  reset() {
    pause();
    setState(() {
      startText = '';
      middleText = '';
      endText = temp;
      incr = 0;
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

  stringFormat() {
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
    setState(() {});
  }

  initTts() {
    flutterTts.completionHandler = () {
      if (incr == listOfLines.length - 1) {
        setState(() {
          incr = 0;
          startText = '';
          middleText = '';
          endText = temp;
          words = temp.split(" ");
          widget.playingStatus(TtsState.STOPPED);
          widget.onComplete();
        });
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
          widget.playingStatus(TtsState.STOPPED);
          widget.onComplete();
        });
      }
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

  skipWord() {
    setState(() {
      startText = startText + words.removeAt(0) + ' ';
    });
  }

  Future<dynamic> pause() => flutterTts.stop().then((s) {
        if (s == 1) {
          if (widget.playingStatus != null)
            widget.playingStatus(TtsState.PAUSE);
        }
      });

  Future<dynamic> speak() async {
    final middle = version >= 8 ? words.join(' ') : listOfLines[incr];
    return await _speak(middle);
  }

  Future<dynamic> _speak(String text) => flutterTts.speak(text).then((s) {
        if (s == 1) {
          if (version < 8) {
            highlight();
          } else {}
          if (widget.playingStatus != null)
            widget.playingStatus(TtsState.PLAYING);
        }
      });

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
        child: Text(
          data + space,
          style: widget.textStyle
        ),
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
              fontSize: widget.textStyle.fontSize, color: widget.highLightColor),
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
    return Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}

Map<int, int> get sdkIntValue {
  return {5: 21, 6: 23, 7: 25, 8: 26, 9: 28};
}
