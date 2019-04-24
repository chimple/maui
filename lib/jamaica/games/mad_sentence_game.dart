import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MadSentenceGame extends StatefulWidget {
  final List<List<String>> words;
  final List<String> header;
  const MadSentenceGame({Key key, this.words, this.header}) : super(key: key);
  @override
  _MadSentenceGameState createState() => new _MadSentenceGameState();
}

class _MadSentenceGameState extends State<MadSentenceGame> {
  int _buttonKey = 0;
  String sentence = '';
  Map<int, String> _wordPos = Map();

  @override
  void initState() {
    super.initState();
    initializeSentence();
  }

  initializeSentence() {
    for (int i = 0; i < widget.words.length; i++) {
      _wordPos[i] = widget.words[i][0];
    }
  }

  Widget _scrollTiles(BuildContext context, List<String> words, int button) {
    final buttonConfig = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            widget.header[button],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 40.0,
            ),
          ),
          CupertinoPicker(
            looping: true,
            // magnification: 1.5,
            backgroundColor: Colors.white,
            diameterRatio: 1.5,
            itemExtent: buttonConfig.height * 0.15,
            onSelectedItemChanged: (i) {
              _wordPos[button] = widget.words[button][i];
            },
            children: words.map((w) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Image.asset("assets/masking/pattern_02.png"),
                  IconButton(
                    icon: Icon(Icons.face),
                    color: Colors.blue,
                    iconSize: 50,
                    onPressed: () {},
                  ),
                  Text(
                    w,
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/background_image/New-Blue-Background.jpg'),
                fit: BoxFit.fill),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: FadeAnimatedTextKit(
                // isRepeatingAnimation: false,
                text: [
                  _wordPos[0],
                  _wordPos[0] + " " + _wordPos[1],
                  _wordPos[0] + " " + _wordPos[1] + " " + _wordPos[2]
                ],
                textStyle: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart,
              ),
              // child: Container(
              //   child: Text(
              //     _sentence,
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 50.0,
              //     ),
              //   ),
              // ),
            ),
            Flexible(
              flex: 2,
              child: GridView.count(
                shrinkWrap: true,
                mainAxisSpacing: 5.0,
                crossAxisCount: 3,
                children: widget.words.map((s) {
                  return _scrollTiles(context, s, _buttonKey++);
                }).toList(growable: false),
              ),
            ),
            FloatingActionButton.extended(
              backgroundColor: Colors.orangeAccent,
              onPressed: () {
                setState(() {
                  sentence =
                      _wordPos[0] + " " + _wordPos[1] + " " + _wordPos[2];
                });
              },
              icon: Icon(
                Icons.done,
                size: 40.0,
              ),
              label: Text(
                "Done",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }
}
