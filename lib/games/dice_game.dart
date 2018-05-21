import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
// import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';

class Dice extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Dice(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.isRotated = false,
      this.gameConfig})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new DiceGameState();
}
enum Stext1 {Active, Visible}
enum Stext2 { Right, InActive }
enum Statuses {right,wrong}

class DiceGameState extends State<Dice> {
  var flag1 = 0;
  var correct = 0;

  var keys = 0;
 static List<String> data = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  static List<String> data1 = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  List<String> _rightwords = [];
  List<Stext1> _status1=[];
  List<Stext2> _status2=[];
  List<Statuses> _statusList ;

  List<String> diceData = ['1', '2', '3', '4', '5', '6'];
  List _sortletters = [];
  bool _isLoading = true;
  List<int> dice_tries = [];
  int code, dindex, dcode;
  List<String> arr = new List<String>();
  String _counter = "";
  String _counter1 = "1";
  String _counter2 = "";
  String _counter3 = "";
 int count=0;
 int count1=0;
 int sum=0;
 int sub=0;
 int flag=0;
 var flag2=0;

  @override
  void initState() {
    super.initState();
    _initBoard();
    _statusList=[];
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _status1 = data.map((a)=>Stext1.Active).toList(growable: false);
    _status2 = data.map((a)=>Stext2.InActive).toList(growable: false);
    //  _status1 = data.map((a)=>Stext1.Active).toList(growable: false);
    // _status2 = data.map((a)=>Stext2.InActive).toList(growable: false);


  }
   Widget _plyer1Side(BuildContext context, double buttonPadding) {
    var j = 0, h = 0, k = 100;
    return new ResponsiveGridView(
      rows: 2,
      cols: 6,
      children: data.map((e) => Padding(
              padding: EdgeInsets.all(buttonPadding),
              child: _buildItem(j=0, e,_status1[j],_status2[j++]))).toList(growable: false),
    );
  }

  Widget _plyer2Side(BuildContext context, double buttonPadding) {
    var j = 0, h = 0, k = 100;
    return new ResponsiveGridView(
      rows: 2,
      cols: 6,
      children: data1.map((e) => Padding(
              padding: EdgeInsets.all(buttonPadding),
              child: _buildItem(j=0, e,_status1[j],_status2[j++]))).toList(growable: false),
    );
  }

  Widget _buildItem(int index, String text,Stext1 status,Stext2 status2) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
      status: status,
      status2: status2,
        color1: 1,
        onPress: () {
          count1=count1+1;
            setState(() {
              var btnVal = int.parse(text);
              for (var i = 0; i < dice_tries.length; i++) {

                sum = sum + dice_tries[i];
                sub = dice_tries[i] - (sub);
                print({"manu sum": sum});
                print({"manu sub": sub});
              }
              if(sub < 0) {
                sub = -sub;
              }
              _status1.forEach((e){
                if(e==Stext1.Visible)
                  {
                    flag2=1;
                  } 
              });
             _status2.forEach((e){
               if(e==Stext2.InActive)
               {
                 flag2=0;
               }
             });

              if(flag2==0) {
                if (status == Stext1.Active) {
                  if (btnVal == sum) {
                    count = 0;
                    dice_tries.removeRange(0, dice_tries.length);
                    _counter = " ";
                    _counter1 = " ";
                    _counter2 = " ";
                    _counter3 = " ";
                    sum = 0;
                    sub = 0;

                   setState(() {
                     _status1[index] = Stext1.Visible;
                   });
                    if (flag == 0) {
                      flag = 1;
                    }
                    else {
                      flag = 0;
                    }
                  }

                  else if (sub == btnVal) {
                    // flag = 1;
                    count = 0;
                    dice_tries.removeRange(0, dice_tries.length);
                    _counter = " ";
                    _counter1 = " ";
                    _counter2 = " ";
                    _counter3 = " ";
                    sub = 0;
                    sum = 0;
                    if (flag == 0) {
                      flag = 1;
                    }
                    else {
                      flag = 0;
                    }
                  }
                  // else {
                  //   sum = 0;
                  // }
                }
              }
              else {
                print("mannu is data is");
                if (status == Stext1.Active) {
                  if (btnVal == sum) {
                    count = 0;
                    dice_tries.removeRange(0, dice_tries.length);
                    _counter = " ";
                    _counter1 = " ";
                    _counter2 = " ";
                    _counter3 = " ";
                    sum = 0;
                    sub = 0;
                    setState(() {
                      _status1[index] = Stext1.Visible;
                      _status2[index]=Stext2.Right;
                    });
//                setState(() {
//                  text[i] = null;
//                });
                    if (flag == 0) {
                      flag = 1;
                    }
                    else {
                      flag = 0;
                    }
                  }

                  else if (sub == btnVal) {
                    flag = 1;
                    count = 0;
                    dice_tries.removeRange(0, dice_tries.length);
                    _counter = " ";
                    _counter1 = " ";
                    _counter2 = " ";
                    _counter3 = " ";
                    sub = 0;
                    sum = 0;
                    if (flag == 0) {
                      flag = 1;
                    }
                    else {
                      flag = 0;
                    }
                  }
                  // else {
                  //   sum = 0;
                  // }

                  _status2 = data.map((a)=>Stext2.InActive).toList(growable: false);
                  _status1 = data1.map((a)=>Stext1.Active).toList(growable: false);
                }
                flag2=0;
              }
              print("hellow manuuuu $text");
            });

        },
        );
  }

  void _randomVal() {
    setState(() {
      if(flag==0) {
        if (count <= 1) {
          count = count + 1;
          final _random = new Random();
          var dElement = diceData[_random.nextInt(diceData.length)];

          var randval = int.parse(dElement);
          dice_tries.add(randval);
          _counter1 = dElement;
          _counter = "$_counter" + "$dElement" + ",";
          print("dice data $_counter ");
        }
      }
      else {
        if(count <= 1) {
          count = count + 1;
          final _random = new Random();
          var dElement = diceData[_random.nextInt(diceData.length)];

          var randval = int.parse(dElement);
          dice_tries.add(randval);
          _counter1 = dElement;
          _counter3 = "$_counter3" + "$dElement" + ",";
          print("dice data $_counter3 ");
        }
    };
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return new LayoutBuilder(builder: (context, constraints) {
    
     final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / 6;

      double maxHeight =(constraints.maxHeight - vPadding * 8) / 6;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);



      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 2, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;

    return new Container(
      padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
        color: Colors.white,
        child: new Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
               child: _plyer1Side(context, buttonPadding),
            ),
            new Row(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           new Container(
              height: media.size.height > media.size.width ?constraints.maxHeight*.08 : constraints.maxHeight*.1 ,
               width: media.size.height < media.size.width? constraints.maxWidth*.1 : constraints.maxWidth*.2 ,
             color: Colors.red,
               margin: EdgeInsets.only(right: 20.0),
               child: new Center(
                   child: new Text("$_counter",
                       style: new TextStyle(
                           color: Colors.black, fontSize: 25.0)))
           ),
       new InkWell(
          onTap: _randomVal,
           child: new Container(
              height: media.size.height > media.size.width ?constraints.maxHeight*.15 : constraints.maxHeight*.2 ,
               width: media.size.height < media.size.width? constraints.maxWidth*.15 : constraints.maxWidth*.2 ,

              // decoration: new BoxDecoration(
              //   color: const Color(0xFFF1F8E9),
              //   boxShadow: [new BoxShadow(
              //     color: Colors.green,
              //     blurRadius: 5.0,
              //   ),
              //   ],
              //   border: new Border.all(
              //     color: Colors.black,
              //     width: 5.0,
              //   ),
              // ),
              child: new Image(

              image:new AssetImage('assets/$_counter1.png')


              //style: new TextStyle(fontSize: 50.0))
            ))),
           new Container(
           height: media.size.height > media.size.width ?constraints.maxHeight*.08 : constraints.maxHeight*.1 ,
               width: media.size.height < media.size.width? constraints.maxWidth*.1 : constraints.maxWidth*.2 ,
             color: Colors.blue,
               margin: EdgeInsets.only(left: 20.0),
               child: new Center(
                   child: new Text("$_counter3",
                       style: new TextStyle(
                           color: Colors.black, fontSize: 25.0)))

           ),
            ]),
            new Expanded(
               child: _plyer2Side(context, buttonPadding),
            ),
          ],
        ));
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.index,
      this.text,
      this.color1,
      this.flag,
      this.onAccepted,
      this.code,
      this.isRotated,
      this.img,
        this.status,
        this.status2,
        this.onPress,
      this.keys})
      : super(key: key);
  final index;
  final int color1;
  final int flag;
  final int code;
  Stext1 status;
  Stext2 status2;
  final bool isRotated;
  final String text;
  final String img;
  final VoidCallback onPress;
  final DragTargetAccept onAccepted;
  final keys;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String _displayText;
  String newtext = '';
  var f = 0;
  var i = 0;

  initState() {
    super.initState();
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate)
          ..addStatusListener((state) {});
    controller.forward();
    animation1 = new Tween(begin: -5.0, end: 5.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    MediaQueryData media = MediaQuery.of(context);
    return new ScaleTransition(
        scale: animation,
        child:new Container(
          // color: Colors.white,
        child: new UnitButton(
          onPress: widget.onPress,
          text: widget.text,
          unitMode: UnitMode.text,
        )));
  }
}
