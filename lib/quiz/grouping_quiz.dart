import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:maui/components/quiz_button.dart';
import 'package:maui/components/quiz_question.dart';

const Map<String, dynamic> testMap = {
  'image': 'xyz.png',
  'question': 'Group the Animals according to the Wild and Pet Animals...?',
  'groupNames': ['Wild Animals', 'Pet Animals'],
  'groups': [
    ['Tiger', 'Lion', 'Fox', 'Cheetah', 'Deer', 'Bear', 'Leopard'],
    ['Dog', 'Cat', 'Cow', 'Parrot', 'Duck', 'Fish', 'Donkey']
  ],
};

class GroupingQuiz extends StatefulWidget {
  final Map<String, dynamic> input;
  final Function onEnd;
  GroupingQuiz({Key key, this.input = testMap, this.onEnd}) : super(key: key);

  @override
  _GroupingQuizState createState() => new _GroupingQuizState();
}

class _GroupingQuizState extends State<GroupingQuiz> {
  String question = 'Question..!!';
  String image = ' ';
  bool gameEnd = false;
  bool showMode = false;
  int correct = 0;
  int total;
  List<String> groupNames = [];
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
    image = widget.input['image'];
    question = widget.input['question'];
    groupNames = widget.input['groupNames'].cast<String>();
    options = [
      widget.input['groups'][0].cast<String>(),
      widget.input['groups'][1].cast<String>()
    ];

    options[0].forEach((f) {
      itemsOfgroupA.add(f);
      allOptions.add(f);
    });

    options[1].forEach((f) {
      itemsOfgroupB.add(f);
      allOptions.add(f);
    });

    total = allOptions.length;
    showMode = widget.input['correct'] == null ? false : true;
    showMode == true
        ? optionsOfGroupA = widget.input['optionsOfGroupA'].cast<String>()
        : null;
    showMode == true
        ? optionsOfGroupB = widget.input['optionsOfGroupB'].cast<String>()
        : null;
    print("allOptions and showMode: ${allOptions.length} , ${showMode}");

    showMode == false
        ? shuffledOptions.addAll(
            allOptions.take(allOptions.length).toList(growable: false)
              ..shuffle())
        : null;

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
    print("_removeData Call Back..!!");
    setState(() {
      shuffledOptions.remove(str);
      if (shuffledOptions.isEmpty) {
        print("Game Over..!!");
        gameEnd = true;
        new Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            widget.onEnd({
              'optionsOfGroupA': optionsOfGroupA,
              'optionsOfGroupB': optionsOfGroupB,
              'correct': correct,
              'total': total
            });
          });
        });
      }
    });
    print("shuffledOptions after remove() $str: ${shuffledOptions}");
  }

  void _incrementCorrect() {
    print("_incrementCorrect Call Back..!!");
    setState(() {
      correct++;
    });
    print("_incrementCorrect ${correct}");
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    return new Container(
      height: size.height * 0.5856,
      child: new GameUI(
          showMode: showMode,
          incrementCorrect: _incrementCorrect,
          removeData: _removeData,
          question: question,
          groupNames: groupNames,
          scrollControllerForGroupA: _scrollControllerForGroupA,
          optionsOfGroupA: optionsOfGroupA,
          itemsOfgroupA: itemsOfgroupA,
          shuffledOptions: shuffledOptions,
          scrollControllerForGroupB: _scrollControllerForGroupB,
          optionsOfGroupB: optionsOfGroupB,
          itemsOfgroupB: itemsOfgroupB,
          gameEnd: gameEnd),
    );
  }
}

class GameUI extends StatefulWidget {
  bool isDragging = false;
  final bool showMode;
  final Function() incrementCorrect;
  final Function(String) removeData;
  final String question;
  final bool gameEnd;
  final ScrollController scrollControllerForGroupA;
  final List<String> groupNames;
  final List<String> optionsOfGroupA;
  final List<String> itemsOfgroupA;
  final List<String> shuffledOptions;
  final ScrollController scrollControllerForGroupB;
  final List<String> optionsOfGroupB;
  final List<String> itemsOfgroupB;

  GameUI({
    Key key,
    @required this.isDragging,
    @required this.showMode,
    @required this.incrementCorrect,
    @required this.removeData,
    @required this.question,
    @required this.gameEnd,
    @required this.groupNames,
    @required this.scrollControllerForGroupA,
    @required this.optionsOfGroupA,
    @required this.itemsOfgroupA,
    @required this.shuffledOptions,
    @required this.scrollControllerForGroupB,
    @required this.optionsOfGroupB,
    @required this.itemsOfgroupB,
  }) : super(key: key);

  @override
  GameUIState createState() {
    return new GameUIState();
  }
}

class GameUIState extends State<GameUI> {
  bool isDragging = false;
  void onDragStarted() {
    setState(() {
      isDragging = true;
    });
  }

  void onDragCompleted() {
    setState(() {
      isDragging = false;
    });
  }

  void onDraggableCanceled() {
    setState(() {
      isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      print("Size ${constraints.maxHeight} , ${constraints.maxWidth}");
      return new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
        ),
        child: new Flex(
          direction: Axis.vertical,
          children: <Widget>[
            widget.showMode == false
                ? Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Container(
                        height: constraints.maxHeight * 0.0871,
                        child: new QuizQuestion(
                          text: widget.question,
                        ),
                      ),
                    ),
                  )
                : new Container(),
            Expanded(
              flex: 6,
              child: Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new GroupUI(
                        showMode: widget.showMode,
                        incrementCorrect: widget.incrementCorrect,
                        removeData: widget.removeData,
                        maxHeight: constraints.maxHeight,
                        maxWidth: constraints.maxWidth,
                        group: widget.groupNames[0],
                        optionsOfGroup: widget.optionsOfGroupA,
                        itemsOfgroup: widget.itemsOfgroupA,
                        scrollControllerForGroup:
                            widget.scrollControllerForGroupA,
                        shuffledOptions: widget.shuffledOptions,
                        gameEnd: widget.gameEnd),
                    new Padding(
                      padding: const EdgeInsets.all(5.0),
                    ),
                    new GroupUI(
                        showMode: widget.showMode,
                        incrementCorrect: widget.incrementCorrect,
                        removeData: widget.removeData,
                        maxHeight: constraints.maxHeight,
                        maxWidth: constraints.maxWidth,
                        group: widget.groupNames[1],
                        optionsOfGroup: widget.optionsOfGroupB,
                        itemsOfgroup: widget.itemsOfgroupB,
                        scrollControllerForGroup:
                            widget.scrollControllerForGroupB,
                        shuffledOptions: widget.shuffledOptions,
                        gameEnd: widget.gameEnd),
                  ],
                ),
              ),
            ),
            widget.showMode == false
                ? Expanded(
                    flex: 3,
                    child: new Center(
                      child: new Container(
                        color: Colors.white,
                        child: GridView.count(
                          childAspectRatio:
                              constraints.maxHeight > 1000 ? 3.0 : 2.0,
                          crossAxisCount: 2,
                          children: new List.generate(
                              widget.shuffledOptions.length, (i) {
                            return new Container(
                              margin: const EdgeInsets.all(8.0),
                              child: new DragBox(
                                isDragging: isDragging,
                                onDragStarted: onDragStarted,
                                onDragCompleted: onDragCompleted,
                                onDraggableCanceled: onDraggableCanceled,
                                label: widget.shuffledOptions[i],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  )
                : new Container(),
          ],
        ),
      );
    });
  }
}

class GroupUI extends StatelessWidget {
  const GroupUI({
    Key key,
    @required this.showMode,
    @required this.incrementCorrect,
    @required this.removeData,
    @required this.maxHeight,
    @required this.maxWidth,
    @required this.group,
    @required this.optionsOfGroup,
    @required this.itemsOfgroup,
    @required this.scrollControllerForGroup,
    @required this.shuffledOptions,
    @required this.gameEnd,
  }) : super(key: key);
  final showMode;
  final Function() incrementCorrect;
  final Function(String) removeData;
  final String group;
  final bool gameEnd;
  final List<String> optionsOfGroup;
  final List<String> itemsOfgroup;
  final ScrollController scrollControllerForGroup;
  final List<String> shuffledOptions;
  final double maxHeight;
  final double maxWidth;
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
          key: Key('Target'),
          onAccept: (String label) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scrollControllerForGroup.animateTo(
                scrollControllerForGroup.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
            if (itemsOfgroup.contains(label)) {
              incrementCorrect();
            }
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
              width: maxWidth * 0.486,
              height:
                  maxHeight < maxWidth ? maxHeight * 0.5059 : maxHeight * 0.557,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: showMode == false ? Color(0x44000000) : Colors.white,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
              ),
              margin: const EdgeInsets.only(left: 0.0),
              child: Center(
                  child: new ListView.builder(
                controller: scrollControllerForGroup,
                physics:
                    showMode == true ? NeverScrollableScrollPhysics() : null,
                itemCount: showMode == false
                    ? optionsOfGroup?.length
                    : itemsOfgroup?.length,
                itemBuilder: (context, i) => new Container(
                      margin: const EdgeInsets.all(7.0),
                      child: new QuizButton(
                        text: showMode == false
                            ? optionsOfGroup[i]
                            : itemsOfgroup[i],
                        buttonStatus: showMode == false
                            ? gameEnd
                                ? itemsOfgroup.contains(optionsOfGroup[i])
                                    ? Status.correct
                                    : Status.incorrect
                                : Status.notSelected
                            : optionsOfGroup.contains(itemsOfgroup[i])
                                ? Status.correct
                                : Status.incorrect,
                        onPress: () {},
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
  final bool isDragging;
  final Function onDragStarted;
  final Function onDragCompleted;
  final Function onDraggableCanceled;

  DragBox(
      {this.isDragging,
      this.onDragStarted,
      this.onDragCompleted,
      this.onDraggableCanceled,
      this.label})
      : super();

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
    return new LayoutBuilder(builder: (context, constraints) {
      print("Size ${constraints.maxHeight} , ${constraints.maxWidth}");
      return Draggable(
        key: Key('Source'),
        onDragStarted: () {
          widget.onDragStarted();
        },
        onDragCompleted: () {
          widget.onDragCompleted();
        },
        onDraggableCanceled: (Velocity v, Offset o) {
          widget.onDraggableCanceled();
        },
        maxSimultaneousDrags: widget.isDragging == true ? 0 : 1,
        data: widget.label,
        child: new QuizButton(
          text: widget.label,
          buttonStatus: Status.notSelected,
          onPress: () {},
        ),
        feedback: Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: new QuizButton(
            text: widget.label,
            buttonStatus: Status.notSelected,
            onPress: () {},
          ),
        ),
      );
    });
  }
}
