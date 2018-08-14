import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const Map<String, dynamic> testMap = {
  'image': 'xyz.png',
  'question': 'Group the Animals according to the Wild and Pet Animals...?',
  'groupNames': ['Wild Animals', 'Pet Animals'],
  'groups': [
    ['Tiger', 'Lion', 'Fox', 'Cheetah', 'Deer', 'Bear', 'Leopard'],
    ['Dog', 'Cat', 'Cow', 'Parrot', 'Duck', 'Fish', 'Donkey']
  ]
};

class GroupingQuiz extends StatefulWidget {
  final Map<String, dynamic> input;
  Function onEnd;
  GroupingQuiz({this.input = testMap, this.onEnd});

  @override
  _GroupingQuizState createState() => new _GroupingQuizState();
}

class _GroupingQuizState extends State<GroupingQuiz> {
  String question = 'Question..!!';
  String image = ' ';
  bool gameEnd = false;
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
    image = testMap['image'];
    question = testMap['question'];
    options = testMap['groups'];

    options[0].forEach((f) {
      itemsOfgroupA.add(f);
      allOptions.add(f);
    });

    options[1].forEach((f) {
      itemsOfgroupB.add(f);
      allOptions.add(f);
    });

    shuffledOptions.addAll(
        allOptions.take(allOptions.length).toList(growable: false)..shuffle());

    print("Image: ${image}");
    print("Question: ${question}");
    print("Groups: ${options}");
    print("groupA: ${itemsOfgroupA}");
    print("groupB: ${itemsOfgroupB}");
    print("optionsOfGroupA: ${optionsOfGroupA}");
    print("optionsOfGroupB: ${optionsOfGroupB}");
    print("allOptions: ${allOptions}");
    print("shuffledOptions: ${shuffledOptions}");
  }

  void _removeData(String str) {
    print("Call Back..!!");
    setState(() {
      shuffledOptions.remove(str);
      if (shuffledOptions.isEmpty) {
        print("Game Over..!!");
        gameEnd = true;
        new Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            widget.onEnd();
          });
        });
      }
    });
    print("shuffledOptions after remove() $str: ${shuffledOptions}");
  }

  @override
  Widget build(BuildContext context) {
    return new GameUI(
        removeData: _removeData,
        question: question,
        scrollControllerForGroupA: _scrollControllerForGroupA,
        optionsOfGroupA: optionsOfGroupA,
        itemsOfgroupA: itemsOfgroupA,
        shuffledOptions: shuffledOptions,
        scrollControllerForGroupB: _scrollControllerForGroupB,
        optionsOfGroupB: optionsOfGroupB,
        itemsOfgroupB: itemsOfgroupB,
        gameEnd: gameEnd);
  }
}

class GameUI extends StatelessWidget {
  final Function(String) removeData;
  final String question;
  final bool gameEnd;
  final ScrollController scrollControllerForGroupA;
  final List<String> optionsOfGroupA;
  final List<String> itemsOfgroupA;
  final List<String> shuffledOptions;
  final ScrollController scrollControllerForGroupB;
  final List<String> optionsOfGroupB;
  final List<String> itemsOfgroupB;
  final String groupA = 'Wild Animals';
  final String groupB = 'Pet Animals';

  const GameUI({
    Key key,
    @required this.removeData,
    @required this.question,
    @required this.gameEnd,
    @required this.scrollControllerForGroupA,
    @required this.optionsOfGroupA,
    @required this.itemsOfgroupA,
    @required this.shuffledOptions,
    @required this.scrollControllerForGroupB,
    @required this.optionsOfGroupB,
    @required this.itemsOfgroupB,
  }) : super(key: key);

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
                  question,
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
                  new GroupUI(
                      removeData: removeData,
                      group: groupA,
                      optionsOfGroup: optionsOfGroupA,
                      itemsOfgroup: itemsOfgroupA,
                      scrollControllerForGroup: scrollControllerForGroupA,
                      shuffledOptions: shuffledOptions,
                      gameEnd: gameEnd),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                  ),
                  new GroupUI(
                      removeData: removeData,
                      group: groupB,
                      optionsOfGroup: optionsOfGroupB,
                      itemsOfgroup: itemsOfgroupB,
                      scrollControllerForGroup: scrollControllerForGroupB,
                      shuffledOptions: shuffledOptions,
                      gameEnd: gameEnd),
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
                  children: new List.generate(shuffledOptions.length, (i) {
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
                      child: new DragBox(shuffledOptions[i]),
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

class GroupUI extends StatelessWidget {
  const GroupUI({
    Key key,
    @required this.removeData,
    @required this.group,
    @required this.optionsOfGroup,
    @required this.itemsOfgroup,
    @required this.scrollControllerForGroup,
    @required this.shuffledOptions,
    @required this.gameEnd,
  }) : super(key: key);
  final Function(String) removeData;
  final String group;
  final bool gameEnd;
  final List<String> optionsOfGroup;
  final List<String> itemsOfgroup;
  final ScrollController scrollControllerForGroup;
  final List<String> shuffledOptions;
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Center(
          child: Text(
            group,
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
              scrollControllerForGroup.animateTo(
                scrollControllerForGroup.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
            if (optionsOfGroup.contains(label)) {
              return;
            } else {
              optionsOfGroup.add(label);
              removeData(label);
            }
          },
          builder: (BuildContext context, List<dynamic> accepted,
              List<dynamic> rejected) {
            return new Container(
              width: 200.0,
              height: 380.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: group == 'GroupA' ? Colors.blue : Colors.purple,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
              ),
              margin: const EdgeInsets.only(left: 0.0),
              child: Center(
                  child: new ListView.builder(
                controller: scrollControllerForGroup,
                itemCount: optionsOfGroup?.length,
                itemBuilder: (context, i) => new Container(
                      margin: const EdgeInsets.all(7.0),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black, width: 3.0),
                        boxShadow: [
                          new BoxShadow(
                            color: const Color(0x44000000),
                            spreadRadius: 2.0,
                            offset: const Offset(0.0, 1.0),
                          )
                        ],
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      child: new RaisedButton(
                        color: gameEnd
                            ? itemsOfgroup.contains(optionsOfGroup[i])
                                ? Colors.green
                                : Colors.red
                            : Colors.grey,
                        splashColor: Colors.grey,
                        onPressed: () {
                          print("Hello World..!!");
                        },
                        child: new Center(
                          child: new Text(
                            optionsOfGroup[i],
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 38.0,
                            ),
                          ),
                        ),
                      ),
                    ),
              )),
            );
          },
        ),
      ],
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
