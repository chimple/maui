import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

const Map<String, dynamic> testMap = {
'image': 'xyz.png',
'question': 'Match the following according to the habitat of each animal',
'order': '["abcd.png", "defg.png", "hijk.png", "lmno.png"]'
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
  bool _isLoading = true;
  var keys = 0;
  Tuple3<String, String, List<String>> _allques;
  String questionText;
  String ans;
  List<String> ch;
  List<String> choice = []; 

  @override
  void initState() {
    super.initState();
    _initboard();
  }

  void _initboard() {
    setState(() => _isLoading = true);
    choice = [];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Question text - ${widget.input['question']}");
  }

}