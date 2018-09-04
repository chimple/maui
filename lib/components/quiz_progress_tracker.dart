import 'package:flutter/material.dart';
import '../repos/quiz_progress_repo.dart';

class QuizProgressTracker extends StatefulWidget{
   final String topicId;

   QuizProgressTracker({
     Key key,
     this.topicId
   }) : super(key : key);

   @override
   State createState() => new QuizProgressTrackerState();
}

class QuizProgressTrackerState extends State<QuizProgressTracker> {
  double _quizProgress;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async{   
   _quizProgress =
        await QuizProgressRepo().getScoreSummaryByTopicId(widget.topicId); 
  }

  @override
  Widget build(BuildContext context) {
    
    return new Container(
      child: _quizProgress != null ? new LinearProgressIndicator(value: _quizProgress) : new Container(),
      );

  }
}