import 'package:flutter/material.dart';

import '../components/QuizButton.dart';
import '../components/quiz_question.dart';
import '../db/entity/quiz.dart';
import '../repos/quiz_repo.dart';

const Map<String, dynamic> _homework = {
  'image': 'lion',
  'questions': "#This animal is a carnivorous reptile.",
  'answer': 'lion',
  'choices': ["Cat", "Sheep", "lion", "Cow"],
};

class Multiplechoice extends StatefulWidget {
  final Map<String, dynamic> input;
  Function onEnd;
  Multiplechoice({Key key, this.input = _homework, this.onEnd})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new MultiplechoiceState();
  }
}

class MultiplechoiceState extends State<Multiplechoice> {
//    List<Quiz> _quizzes;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initState();
//   }

//   void _initState() async {
// //TODO: Link to topic
//     _quizzes = await QuizRepo().getQuizzesByTopicId('lion');
//     setState(() {
//       _isLoading = false;
//     });
//   }
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    List<String> choices = widget.input['choices'];
    print("hello data is.....::${widget.input['choices']}");
    return new Container(
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: new Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(10.0)),
          new SingleChildScrollView(
            child: Container(
              height: size.height / 2,
              color: Colors.amber,
              child: QuizQuestion(
                text: widget.input['questions'],
                image: 'assets/Animals.png',
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(10.0)),
          Expanded(
            child: Container(
                child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              shrinkWrap: true,
              children: choices.map((element) {
                print("the dataq is.....$element");
                return new QuizButton(text: element, onPress: onPress);
              }).toList(growable: false),
            )),
          ),
        ],
      ),
    );
  }

  onPress() {
    setState(() {
      widget.onEnd();
    });
  }
}
