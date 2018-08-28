import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/db/dao/quiz_progress_dao.dart';
import 'package:maui/db/entity/quiz_progress.dart';
import '../repos/quiz_progress_repo.dart';

class TopicButton extends StatefulWidget {
  final String text;
  final int color;
  final String image;
  final VoidCallback onPress;
  String topicId;
  

  TopicButton({
    Key key,
    @required this.text,
    this.color,
    this.image,
    this.onPress,
    this.topicId,
//      this.sizeHieght,
//      this.sizeWidth
  }) : super(key: key);
  
  @override
  State createState() => new TopicButtonState();

}

class TopicButtonState extends State<TopicButton>{
  QuizProgress _quizProgress;
  bool _isLoading = true;
  var doneStatus;

  @override
  void initState() {
    super.initState();
    print("Topic Id received at topic Button - ${widget.topicId}");
    widget.topicId == null ? "animals" : widget.topicId;
    _initData();
  }

  void _initData() async{
    setState(() => _isLoading = true);
   _quizProgress =
        await QuizProgressRepo().getQuizProgressByTopicId(widget.topicId);    
    doneStatus = (double.parse(_quizProgress.maxScore)/double.parse(_quizProgress.outOfTotal));  
    setState(() => _isLoading = false);
    
  }

  @override
  Widget build(BuildContext context) {
    print("Current QuizProgress - $_quizProgress");  
    print("Current QuizProgress Done Status - $doneStatus");

    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    // TODO: implement build
    print("hello Topic button ${widget.image} and ${widget.text}");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Material(
        elevation: 8.0,
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
        child: new Container(
          color: Colors.brown,
          child: new InkWell(
            onTap: widget.onPress,
            child: new Stack(children: [
              new Column(
                children: <Widget>[
                  
                      new Text("Total topics covered - ", style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      new LinearProgressIndicator(value: doneStatus),
                    
                  widget.image == null
                      ? new Expanded(
                          child: Container(color: Colors.red),
                        )
                      : widget.image.endsWith(".svg")
                          ? new Expanded(
                              child: new Container(
                                color: Colors.red,
                                child: new AspectRatio(
                                  aspectRatio: 2.0,
                                  child: new SvgPicture.asset(
                                    widget.image,
                                    allowDrawingOutsideViewBox: false,
                                  ),
                                ),
                              ),
                            )
                          : new Expanded(
                              child: Container(
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new AssetImage(widget.image),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Colors.red),
                              ),
                            ),
                  Container(
                    child: new Text(widget.text,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
//                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
