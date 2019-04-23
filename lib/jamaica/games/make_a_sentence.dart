import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';

class MakeASentence extends StatefulWidget {
  final List<List<String>> words;
  const MakeASentence({Key key, this.words}) : super(key: key);
  @override
  _MakeASentenceState createState() => new _MakeASentenceState();
}

class _MakeASentenceState extends State<MakeASentence> {
  int selectitem = 1;
  int _buttonKey = 0;
  List<String> sentence = List(3);

  Widget _scrollTiles(BuildContext context, List<String> words, int button) {
    final buttonConfig = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CupertinoPicker(
        looping: true,
        // magnification: 1.5,
        backgroundColor: Colors.white,
        diameterRatio: 1.5,
        itemExtent: buttonConfig.height * 0.182,
        onSelectedItemChanged: (i) {
          selectitem = i;
          print(
              "selectitem ====$i ......... ${widget.words[button][i]} ,,,,,,,, $button");
          // sentence.add(widget.words[button][i]);
          sentence[0] = widget.words[0][i];
          print("sentence === $sentence");
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: TyperAnimatedTextKit(
                  onTap: () {
                    print("Tap Event");
                  },
                  text: [
                    "The boy speaks nicely!!!",
                    // "speaks",
                    // " nicely!!!"
                  ],
                  textStyle: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.start,
                  alignment: AlignmentDirectional.topStart),
              // child: Container(
              //   child: Text(
              //     "The boy speaks nicely",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 50.0,
              //     ),
              //   ),
              // ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Who",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 40.0,
                  ),
                ),
                Text(
                  "How",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 40.0,
                  ),
                ),
                Text(
                  "What",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 40.0,
                  ),
                ),
              ],
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
              onPressed: () {},
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
