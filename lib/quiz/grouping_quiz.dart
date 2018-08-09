import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const Map<String, dynamic> testMap = {
  'image': 'xyz.png',
  'question': 'Group the Animals according to the Wild and Pet Animals...?',
  'groups': [
    ['Tiger', 'Lion', 'Fox', 'Cheetah', 'Deer', 'Bear', 'Leopard'],
    ['Dog', 'Cat', 'Cow', 'Parrot', 'Duck', 'Fish', 'Donkey']
  ]
};

class GroupingQuiz extends StatefulWidget {
  final Map<String, dynamic> input;
  GroupingQuiz({this.input = testMap});

  @override
  _GroupingQuizState createState() => new _GroupingQuizState();
}

class _GroupingQuizState extends State<GroupingQuiz> {
  String question = 'Question..!!';
  String image = ' ';
  List<List<String>> options = [];
  List<String> allOptions = [];
  List<String> itemsOfgroupA = [];
  List<String> itemsOfgroupB = [];
  List<String> optionsOfGroupA = [];
  List<String> optionsOfGroupB = [];
  List<String> shuffledOptions = [];
  ScrollController _scrollControllerForGroupA = new ScrollController();
  ScrollController _scrollControllerForGroupB = new ScrollController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    testMap.forEach((k, v) {
      if (k == 'image') {
        image = v;
      }
      if (k == 'question') {
        question = v;
      }
      if (k == 'groups') {
        v.map((f) {
          options.add(f);
        }).toList(growable: false);
        ;
      }
    });
    for (int i = 0; i < options[0].length; i++) {
      itemsOfgroupA.add(options[0][i]);
      allOptions.add(options[0][i]);
    }
    for (int i = 0; i < options[1].length; i++) {
      itemsOfgroupB.add(options[1][i]);
      allOptions.add(options[1][i]);
    }

    shuffledOptions.addAll(
        allOptions.take(allOptions.length).toList(growable: false)..shuffle());

    print("Image: ${image}");
    print("Question: ${question}");
    print("Groups: ${options}");
    print("groupA: ${itemsOfgroupA}");
    print("groupB: ${itemsOfgroupB}");
    print("allOptions: ${allOptions}");
    print("shuffledOptions: ${shuffledOptions}");
  }

  @override
  Widget build(BuildContext context) {
    return new GameUI(
        question: question,
        scrollControllerForGroupA: _scrollControllerForGroupA,
        optionsOfGroupA: optionsOfGroupA,
        shuffledOptions: shuffledOptions,
        scrollControllerForGroupB: _scrollControllerForGroupB,
        optionsOfGroupB: optionsOfGroupB);
  }
}

class GameUI extends StatefulWidget {
  const GameUI({
    Key key,
    @required this.question,
    @required this.scrollControllerForGroupA,
    @required this.optionsOfGroupA,
    @required this.shuffledOptions,
    @required this.scrollControllerForGroupB,
    @required this.optionsOfGroupB,
  }) : super(key: key);

  final String question;
  final ScrollController scrollControllerForGroupA;
  final List<String> optionsOfGroupA;
  final List<String> shuffledOptions;
  final ScrollController scrollControllerForGroupB;
  final List<String> optionsOfGroupB;

  @override
  GameUIState createState() {
    return new GameUIState();
  }
}

class GameUIState extends State<GameUI> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
      ),
      child: new Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: new Container(
              color: Colors.red,
              child: Center(
                child: Text(
                  widget.question,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Group A',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      new DragTarget(
                        onAccept: (String label) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            widget.scrollControllerForGroupA.animateTo(
                              widget.scrollControllerForGroupA.position
                                  .maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });

                          if (widget.optionsOfGroupA.contains(label)) {
                            return;
                          } else {
                            widget.optionsOfGroupA.add(label);
                            setState(() {
                              widget.shuffledOptions.remove(label);
                            });
                            print("shuffledOptions after remove(): ${widget.shuffledOptions}");
                          }
                        },
                        builder: (BuildContext context, List<dynamic> accepted,
                            List<dynamic> rejected) {
                          return new Container(
                            width: 200.0,
                            height: 380.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.blue,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0)),
                            ),
                            margin: const EdgeInsets.only(left: 0.0),
                            child: Center(
                                child: new ListView.builder(
                              controller: widget.scrollControllerForGroupA,
                              itemCount: widget.optionsOfGroupA?.length,
                              itemBuilder: (context, i) => new Container(
                                    margin: const EdgeInsets.all(7.0),
                                    decoration: new BoxDecoration(
                                      border: new Border.all(
                                          color: Colors.black, width: 3.0),
                                      color: Colors.orange,
                                      boxShadow: [
                                        new BoxShadow(
                                          color: const Color(0x44000000),
                                          spreadRadius: 2.0,
                                          offset: const Offset(0.0, 1.0),
                                        )
                                      ],
                                      borderRadius:
                                          new BorderRadius.circular(12.0),
                                    ),
                                    child: new ListTile(
                                      title: new Text(widget.optionsOfGroupA[i],
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                            )),
                          );
                        },
                      ),
                    ],
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                  ),
                  new Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Group B',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      new DragTarget(
                        onAccept: (String label) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            widget.scrollControllerForGroupB.animateTo(
                              widget.scrollControllerForGroupB.position
                                  .maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });

                          if (widget.optionsOfGroupB.contains(label)) {
                            return;
                          } else {
                            setState(() {
                              widget.shuffledOptions.remove(label);
                            });
                            widget.optionsOfGroupB.add(label);
                          }
                        },
                        builder: (BuildContext context, List<dynamic> accepted,
                            List<dynamic> rejected) {
                          return new Container(
                            width: 200.0,
                            height: 380.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.purple,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0)),
                            ),
                            margin: const EdgeInsets.only(left: 0.0),
                            child: Center(
                                child: new ListView.builder(
                              controller: widget.scrollControllerForGroupB,
                              itemCount: widget.optionsOfGroupB?.length,
                              itemBuilder: (context, i) => new Container(
                                    margin: const EdgeInsets.all(7.0),
                                    decoration: new BoxDecoration(
                                      border: new Border.all(
                                          color: Colors.black, width: 3.0),
                                      color: Colors.orange,
                                      boxShadow: [
                                        new BoxShadow(
                                          color: const Color(0x44000000),
                                          spreadRadius: 2.0,
                                          offset: const Offset(0.0, 1.0),
                                        )
                                      ],
                                      borderRadius:
                                          new BorderRadius.circular(12.0),
                                    ),
                                    child: new ListTile(
                                      title: new Text(widget.optionsOfGroupB[i],
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                            )),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: new Center(
              child: new Container(
                color: Colors.white,
                child: GridView.count(
                  childAspectRatio: 2.0,
                  crossAxisCount: 2,
                  children:
                      new List.generate(widget.shuffledOptions.length, (i) {
                    return new Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black, width: 3.0),
                        color: Colors.blueGrey,
                        boxShadow: [
                          new BoxShadow(
                            color: const Color(0x44000000),
                            spreadRadius: 2.0,
                            offset: const Offset(0.0, 1.0),
                          )
                        ],
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      child: new DragBox(widget.shuffledOptions[i]),
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DragBox extends StatefulWidget {
  final String label;

  DragBox(this.label);

  @override
  _DragBoxState createState() => new _DragBoxState();
}

class _DragBoxState extends State<DragBox> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: widget.label,
      child: new RaisedButton(
        color: Colors.grey,
        splashColor: Colors.grey,
        onPressed: () {
          print("Hello World..!!");
        },
        child: new Center(
          child: new Text(
            widget.label,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 40.0,
            ),
          ),
        ),
      ),
      feedback: new RaisedButton(
        color: Colors.grey,
        splashColor: Colors.grey,
        onPressed: () {
          print("Hello World..!!");
        },
        child: new Center(
          child: new Text(
            widget.label,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 38.0,
            ),
          ),
        ),
      ),
    );
  }
}
