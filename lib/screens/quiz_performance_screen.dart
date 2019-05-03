import 'package:flutter/material.dart';

class QuizPerformanceScreen extends StatefulWidget {
  @override
  _QuizPerformanceScreenState createState() => _QuizPerformanceScreenState();
}

class _QuizPerformanceScreenState extends State<QuizPerformanceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quiz Performance Screen",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Quiz Performance Screen"),
        ),
        body: Center(child: Text('Quiz Performance Screen'))
      ),
    );
  }
}