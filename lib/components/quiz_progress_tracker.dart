import 'package:flutter/material.dart';
import 'package:maui/db/dao/quiz_progress_dao.dart';
import 'package:maui/db/entity/quiz_progress.dart';
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
  QuizProgress _quizProgress;
  bool _isLoading = true;
  double _doneStatus;

  @override
  void initState() {
    super.initState();
    print("Welcome to QuizProgressTracker class");
    _initData();
  }

  void _initData() async{
    setState(() => _isLoading = true);
   _quizProgress =
        await QuizProgressRepo().getQuizProgressByTopicId(widget.topicId);    
    _doneStatus = (_quizProgress.maxScore/_quizProgress.outOfTotal);  
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    print("Current QuizProgress - $_quizProgress");  
    print("Current QuizProgress Done Status - $_doneStatus");

    if (_isLoading == true && _quizProgress != null) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new Container(
      child: _quizProgress != null ? new LinearProgressIndicator(value: _doneStatus) : new Container(),
      );

  }
}