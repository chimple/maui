import 'package:flutter/material.dart';
import 'package:maui/components/quiz_progress_tracker.dart';
import '../repos/topic_repo.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/topic.dart';

class TopicView extends StatefulWidget {
  final List quiz;

  TopicView({this.quiz});

  @override
  _TestListState createState() => new _TestListState();
}

class _TestListState extends State<TopicView> {
  List<Topic> _topics;
  List<String> categories = [
    "Gallery",
    "Topic",
  ];
List<Topic> _quizProgress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("Welcome to QuizProgressTracker class");
    _initData();
  }

  void _initData() async{
    setState(() => _isLoading = true);
   _quizProgress =
        await TopicRepo().getAllTopics();    
   print("list quizes is.......::$_quizProgress");
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext ctxt) {
 print("list quizes is.......::$_quizProgress");
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new Container(
        child: new ListView.builder
              (
                itemCount: _quizProgress.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(children: [
                      Row(children: [new Text("${_quizProgress[index].id}")]),
                      new QuizProgressTracker(topicId:_quizProgress[index].id)]),
                  );
                }
            ));
  }
}
