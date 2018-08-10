import 'package:flutter/material.dart';

const Map<String, dynamic> testMap = {
'image': 'stickers/giraffe/giraffe.png',
'question': 'Match the following according to the habitat of each animal',
'order': ["abc.png", "def.png", "xyz.png", "lmn.png"]
};

class SequenceQuiz extends StatefulWidget {
final Map<String, dynamic> input;

const SequenceQuiz(
{Key key, this.input = testMap})
: super(key: key);

@override
  State createState() => new SequenceQuizState();
}

class SequenceQuizState extends State<SequenceQuiz>
{
  var keys = 0;
  String ans;
  int score=0;
  var choice = []; 

  @override
  void initState() {
    super.initState();
    _initboard();
  }

  void _initboard() {
    for(var i=0;i<widget.input['order'].length;i++){
    choice.add(widget.input['order'][i]);}
    ans = widget.input['image'];
  }

  // @override
  // void didUpdateWidget(SequenceQuiz oldWidget) {
  //   print(oldWidget.iteration);
  //   print(widget.iteration);
  //   if (widget.iteration != oldWidget.iteration) {
  //     _initboard();      
  //   }
  // }


  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        ans: this.ans,
        keys: keys++,
        onPress: () {
          if (text == ans) {   
            score+=4;         
            choice.removeRange(0, choice.length);
          } else {            
            if (score > 0) {
              score = score - 1;;
            } else {
              score=0;
            }
          }
        });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Input - ${widget.input}");
    // print("Image - ${widget.input['image']}");

    print("order choice[0] - ${choice[0]}");

    // if (_isLoading) {
    //   return new SizedBox(
    //     width: 20.0,
    //     height: 20.0,
    //     child: new CircularProgressIndicator(),
    //   );
    // }
    
     double ht = MediaQuery.of(context).size.height;
     double wd = MediaQuery.of(context).size.width;

     int j = 0;   
     
     List<Widget> tableRows = new List<Widget>();
    for (var i = 0; i < 2; ++i) {
      List<Widget> cells = choice.cast<String>().map((e) => new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: _buildItem(j++, e),
                    )).toList(growable: false)
          .skip(i * 2)
          .take(2)
          .toList(growable: false);
      tableRows.add( new Column(
            children: cells,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ));
    }


    return new Scaffold(
      backgroundColor: Colors.grey,
     body: new Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: <Widget>[
         
         new Row(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
        new SingleChildScrollView(
           child: new Container(
           height: ht * 0.48,
           width: wd * 0.7,
           decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(20.0),
                    color: Colors.white,
                    border: new Border.all(
                      width: 6.0,
                      color: Colors.grey,
                    ),
                  ),
           child: new Column(
           children: <Widget>[

             //Image's Container
            new Container(
                 height: ht * 0.4,
                 width: wd * 0.4,
                 child: new Image(
                     image: new AssetImage("assets/${widget.input['image']}"),
                   ),
               ),


             // Question's Container
             new Container(
               height: ht * 0.07,
               decoration: new BoxDecoration(
                    // borderRadius: new BorderRadius.circular(20.0),
                    color: const Color(0xFFC0C0C0),                     
                    border: const Border(
                      bottom: const BorderSide(width: 10.0, color: Colors.grey),
                    )
                  ),
               child: new Text("${widget.input['question']}", style: new TextStyle(fontSize: ht * 0.03, fontWeight: FontWeight.bold),),
             ),

           ]),
         )),
           ],),


          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: tableRows,          
           )
         
       ],
     ),
    );
    // });    
    }
}

class MyButton extends StatefulWidget {
  String ans;
  MyButton(
      {Key key,
      this.text,
      this.ans,
      this.keys,
      this.onPress})
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  int keys;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;

    controller = new AnimationController(
        duration: new Duration(milliseconds: 600), vsync: this);
    // wrongController = new AnimationController(
    //     duration: new Duration(milliseconds: 100), vsync: this);

    animation =
        new CurvedAnimation(parent: controller, curve: Curves.elasticOut)
          ..addStatusListener((state) {
//        print("$state:${animation.value}");
            if (state == AnimationStatus.dismissed) {
              print('dismissed');
              if (widget.text != null) {
                setState(() => _displayText = widget.text);
                controller.forward();
              }
            }
          });
    // wrongAnimation = new Tween(begin: -8.0, end: 10.0).animate(wrongController);
    controller.forward();
    // _myAnim();
  }

  // void _myAnim() {
  //   wrongAnimation.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       wrongController.reverse();
  //     } else if (status == AnimationStatus.dismissed) {
  //       wrongController.forward();
  //     }
  //   });
  //   wrongController.forward();
  // }

  @override
  void dispose() {
    // wrongController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    print("_MyButtonState.build");

    double ht = MediaQuery.of(context).size.height;
    double wd = MediaQuery.of(context).size.width;

    return new GestureDetector(
      // onLongPress: () {
      //   showDialog(
      //       context: context,
      //       child: new FractionallySizedBox(
      //           heightFactor: 0.5,
      //           widthFactor: 0.8,
      //           child: new FlashCard(text: widget.text)));
      // },
      // child: new UnitButton(
      //   onPress: () => widget.onPress(),
      //   text: _displayText,
      //   unitMode: widget.unitMode,
              //  child: new ButtonTheme(
              //     minWidth: 100.0,
              //     height: 100.0,
                  child: new ButtonTheme(
                    minWidth: 150.0,
                    height: 150.0,
                    child: new FlatButton(
                   onPressed: () => widget.onPress(),
                   color: const Color(0xFFffffff),
                   shape: new RoundedRectangleBorder(
                       borderRadius:
                       const BorderRadius.all(const Radius.circular(8.0))),
                   child: new Text(_displayText,
                       key: new Key("${widget.keys}"),
                       style:
                       new TextStyle(color: Colors.black, fontSize: ht * 0.05))
      )),
    );
  }
}
