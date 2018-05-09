import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'dart:math';
import 'package:maui/components/unit_button.dart';
import 'dart:async';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/shaker.dart';
class TapWrong extends StatefulWidget {
 Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
 bool isRotated;

  TapWrong({key, this.onScore, this.onProgress, this.onEnd, this.iteration,  this.gameConfig, this.isRotated=false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>new  TapWrongState();
}
enum Statuses {right,wrong}
class TapWrongState extends State<TapWrong> {
String _dispText='';
int num1;
int  numOFWrongElem;
 bool _isLoading = true;
  List<String> word=new List(); //=['D','O','G'];
  List<String> others= new List();//=['X','P'];
List<String> arr1=[];
List<String> proArray=[];
List<Statuses> _statusList ;
Tuple2<List<String>,List<String>> data;
 bool _isShowingFlashCard = false;
   @override
  void initState() {
    super.initState();
    _initBoard();
  }
  void _initBoard() async{
    word=[];
    others=[];
    arr1=[];
    _statusList=[];
    num1=0;
    numOFWrongElem=0;
    _dispText='';
     setState(() => _isLoading = true);
data=await fetchWordData(widget.gameConfig.gameCategoryId,3,2);
   print('datat  ${data.item1}');
    data.item1.forEach((d) {
     
        word.add(d);
      
    });
    data.item2.forEach((d) {
     
        others.add(d);
      
    });
word.forEach((d){
_dispText=_dispText+d;
});
   arr1.addAll(word);
   var lenOfArr1=arr1.length;
   arr1.addAll(others);
       var rand =new Random();
         var randNum =0;
        String temp = '';
        String temp1 = '';
  
        // Randomizing array

        for (int w = 0; w < others.length; w++) {
            randNum =rand.nextInt(arr1.length-1);
            print("random num $randNum");
            print('$arr1');
            temp = arr1[randNum];
            
            arr1[randNum] = others[w];
            print('$arr1');
             print('${arr1.length}');
            for (int q = randNum; q < (lenOfArr1+w ); q++) {
                temp1 = arr1[q + 1];
                arr1[q + 1] = temp;
                temp = temp1;
               // console.log("arr1[q],arr2[w]", arr1[q], this.props.data.others[w]);
                
            }
        }print('array1     $arr1');

         _statusList = arr1.map((a) => Statuses.right).toList(growable: false);
         print('status array      $_statusList');
          setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(TapWrong oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      
    }
  }
 
 Widget _buildItem(int index, String text, Statuses status) {
    return new MyButton(
       key: new ValueKey<int>(index),
        text: text,
        index: index,
        status: status,
        onPress: () {
print("index                         $index");
           int j = 0;
    setState(() {
proArray.addAll(arr1);
      
      proArray.removeAt(index);
print('removed array       $proArray');
print('removed array l3en      ${proArray.length}');
print('word array       $word');
print('disp text   $_dispText');
    
        for (int i = 0; i <proArray.length; i++) {
           
            if ( word[j] == proArray[i]) {
                j++;
            }
             if (j >=  word.length) {break;}
        }

    print('j is now     $j');
      
        if (j >=  word.length) {
            num1++;
          numOFWrongElem++;
       print('array 1           $arr1');
        new Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                 //   _statusList.removeAt(index);
                  arr1.removeAt(index);
                  });});
    
      print('array 1 after     $arr1');
            widget.onScore(2);
            widget.onProgress(num1 / others.length);
            if ( numOFWrongElem ==   others.length) {
              new Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
               _isShowingFlashCard = true; // widget.onEnd();
             }); });
             //  widget.onEnd();
            }
        
        } else {
          _statusList[index]=Statuses.wrong;
          print('status array afdter clicking wrong     $_statusList');
           new Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                 _statusList[index]=Statuses.right;
                  });});
       }
       proArray=[];
  }); }

    );}


  @override
  Widget build(BuildContext context) {
  if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
     if (_isShowingFlashCard) {
      return new FlashCard(
          text:_dispText,
          onChecked: () {
         widget.onEnd();    // _initBoard();
          

            setState(() {
              _isShowingFlashCard = false;
            });
          });
    }
     int j = 0;
   
      return 
        
         new ResponsiveGridView(
           maxAspectRatio: 1.0,
      rows: 1,
      cols: arr1.length,
      children: arr1.map((e) => _buildItem(j, e,_statusList[j++])).toList(growable: false),
      );
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress,this.status,this.index}) : super(key: key);

  final String text;
  final VoidCallback onPress;
  final Statuses status;
  final int index;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller,controller1;
  Animation<double> animation,animation1;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
        controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn);

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
 
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return  new ScaleTransition(
      scale: animation,
      child:new  Shake(
      animation: widget.status == Statuses.wrong?animation1:animation,
      child: new UnitButton(
          onPress: widget.onPress,
          text: widget.text,
          unitMode: UnitMode.text,
        )));
  }
}
