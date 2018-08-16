import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'package:maui/components/quiz_grid.dart';

const Map<String, dynamic> testMap = {
'image': 'stickers/giraffe/giraffe.png',
'question': 'Match the following according to the habitat of each animal',
'order': ["abc", "def", "stickers/giraffe/giraffe.png", "lmn"]
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
    // choice = choice.map((a) => widget.input['order'][a]).toList(growable: false);
    ans = widget.input['image'];
    print("Choices at initializtion -$choice");
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
    return new QuizButton(
        key: new ValueKey<int>(index),
        text: text,
        buttonStatus: text == ans ? Status.correct : Status.incorrect,
        onPress: () {
          print("Score before onPress - $score");
          if (text == ans) { 
            score+=4;      
            print("Score Update - $score");   
            choice.removeRange(0, choice.length);
          } else {            
            if (score > 0) {
              score = score - 1;
            } else {
              score=0;
            }
          }
        });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // print("Input - ${widget.input}");
    // print("Image - ${widget.input['image']}");

    // print("order choice[0] - ${choice[0]}");

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
