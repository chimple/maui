import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'dart:async';
import '../components/quiz_question.dart';

const Map<String, dynamic> _homework = {
  'image': 'lion',
  'questions': "#This animal is a carnivorous reptile.",
  'answer': 'lion',
  'choices': ["Cat", "Sheep", "lion", "Cow"],
};

class Multiplechoice extends StatefulWidget {
  final Map<String, dynamic> input;
  Function onEnd;
  Multiplechoice({Key key, this.input = _homework, this.onEnd})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new MultiplechoiceState();
  }
}

// enum Status { notSelected, correct, incorrect }
enum Statuses { Active, Visible, Disappear, Draggable, Dragtarget, First }
enum ShakeCell { Right, InActive, Dance, CurveRow }

class MultiplechoiceState extends State<Multiplechoice> {
  var val;
  bool showans = false;
  List<Statuses> _statuses = [];
  List<ShakeCell> _shakeCells = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("hello this should come first...");
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    List<String> choices = widget.input['choices'];
    _statuses = choices.map((a) => Statuses.Active).toList(growable: false);
    print("hello this shake cell staius is......$_statuses");
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    var size = media.size;
    List<String> choices = widget.input['choices'];
    var j = 0;
    print("hello data is.....::${widget.input['choices']}");
    return new Container(
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: new Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(10.0)),
          new SingleChildScrollView(
            child: Container(
              height: size.height / 2,
              color: Colors.amber,
              child: QuizQuestion(
                text: widget.input['questions'],
                image: 'assets/Animals.png',
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(10.0)),
          Expanded(
            child: Container(
                child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              shrinkWrap: true,
              children: choices.map((element) {
                print("the dataq is.....$element");
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildItem(j, element, choices, _statuses[j++],
                        widget.input['answer'], val));
              }).toList(growable: false),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int index, String element, List<String> choices,
      Statuses status, input, val) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: element,
        status: status,
        input: input,

        // ? Status.correct
        // : Status.incorrect,
        onPress: () {
          //  setState(() {
          if (!showans) {
            // showans = true;
            if (element == widget.input['answer']) {
              setState(() {
                showans = true;
                print("coorect one is...clicked here$element");
                _statuses[index] = Statuses.Disappear;
                print("values of clor ellement is.....::${ _statuses}");
              });
            } else {
              setState(() {
                showans = true;
                _statuses[index] = Statuses.Dragtarget;
                print(
                    "this. is when we clicked wrong choice in quize is.....;::$_statuses");

                new Future.delayed(const Duration(milliseconds: 500), () {
                  choices.forEach((element) {
                    if (element == widget.input['answer']) {
                      print("after some delay  in quize is.....;::$_statuses");
                      var i = choices.indexOf(element);
                      setState(() {
                        _statuses[i] = Statuses.Disappear;
                      });
                    }
                  });
                });
              });
            }
          }
        });
    // });
  }
}

class MyButton extends StatefulWidget {
  MyButton({
    Key key,
    this.text,
    this.index,
    this.status,
    this.input,
    this.onPress,
  }) : super(key: key);

  final String text;
  int index;
  final String input;
  Statuses status;

  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animationRight, animation, animationWrong, animationDance;
  String _displayText;
  Velocity v;
  Offset o;
  Status currentButtonState;
  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    currentButtonState = Status.notSelected;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 20), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
    animationWrong = new Tween(begin: -2.0, end: 2.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animationWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("0.......data is.... ${widget.status}");

    return new QuizButton(
        text: widget.text,
        buttonStatus: widget.status == Statuses.Active
            ? Status.notSelected
            : widget.status == Statuses.Disappear
                ? Status.correct
                : Status.incorrect,
        onPress: widget.onPress);
  }
}
