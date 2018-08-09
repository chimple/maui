import 'package:flutter/material.dart';

const Map<String, dynamic> _work = {
  'data': [
    {
      'image': 'lion',
      'questions': "#This animal is a carnivorous reptile.",
      'answer': 'lion',
      'choices': ["Cat", "Sheep", "lion", "Cow"],
    },
    {
      'image': 'lion',
      'questions': "_________ zlike to chase mice and birds.",
      'answer': 'Cat',
      'choices': ["Cat", "Snail", "Slug", "Horse"],
    }
  ]
};

class Multiplechoice extends StatefulWidget {
  final Map<String, dynamic> input;
  Multiplechoice({Key key, this.input = _work}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new MultiplechoiceState();
  }
}

class MultiplechoiceState extends State<Multiplechoice> {
  var score = 0;
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    print("hello data is.....::${widget.input['data'][0]['choices']}");
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: new Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(10.0)),
                new SingleChildScrollView(
                  child: Container(
                    height: size.height / 2,
                    color: Colors.amber,
                    child: ListView(
                      children: <Widget>[
                        new Image.asset(
                          "assets/lion.png",
                        ),
                        new Container(
                          child: new Text(
                            "${widget.input['data'][0]['questions']}",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 20.0),
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(10.0)),
                      ],
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(10.0)),
                Expanded(
                  child: Container(
                    color: Colors.amber,
                    child: new GridView.count(
                      crossAxisCount: 2,
                      children: new List.generate(
                          widget.input['data'][0]['choices'].length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new MaterialButton(
                            minWidth: 120.0,
                            color: Colors.blueGrey,
                            onPressed: () {
                              print(
                                  "......data is....${widget.input['data'][0]['choices'][index]}");
                              if (widget.input['data'][0]['choices'][index] ==
                                  widget.input['data'][0]['answer']) {
                                debugPrint("Correct");
                                score++;
                              } else {
                                debugPrint("Wrong");
                              }
                              updateQuestion();
                            },
                            child: new Text(
                              widget.input['data'][0]['choices'][index],
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void updateQuestion() {
    setState(() {});
  }
}
