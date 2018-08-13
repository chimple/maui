import 'package:flutter/material.dart';

import '../components/quiz_question.dart';

const Map<String, dynamic> _homework = {
  'image': 'lion',
  'questions': "#This animal is a carnivorous reptile.",
  'answer': 'lion',
  'choices': ["Cat", "Sheep", "lion", "Cow"],
};

class Multiplechoice extends StatefulWidget {
  final Map<String, dynamic> input;
  Multiplechoice({Key key, this.input = _homework}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new MultiplechoiceState();
  }
}

class MultiplechoiceState extends State<Multiplechoice> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
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
              color: Colors.amber,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: widget.input['choices'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new MaterialButton(
                      minWidth: 120.0,
                      color: Colors.blueGrey,
                      onPressed: () {
                        print(
                            "......data is....${widget.input['choices'][index]}");
                        if (widget.input['choices'][index] ==
                            widget.input['answer']) {
                          print("Correct");
                        } else {
                          print("Wrong");
                        }
                      },
                      child: new Text(
                        widget.input['choices'][index],
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateQuestion() {
    setState(() {});
  }
}
