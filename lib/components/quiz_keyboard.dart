import 'package:flutter/material.dart';

class QuizKeyboard extends StatefulWidget {
  final Function onSubmit;

  QuizKeyboard({Key key, this.onSubmit}) : super(key: key);
  @override
  _QuizKeyboardState createState() => new _QuizKeyboardState();
}

class _QuizKeyboardState extends State<QuizKeyboard> {
  final TextEditingController _textController = new TextEditingController();
  String keyboardAnswer;

  void _handleSubmitted(String text) {
    _textController.clear();
    widget.onSubmit(text);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                onChanged: (String text) {
                  keyboardAnswer = text;
                },
                key: Key("keyboard"),
                keyboardType: TextInputType.text,
                obscureText: false,
                style:
                    TextStyle(fontSize: 40.0, height: 1.5, color: Colors.black),
                maxLines: 1,
                autocorrect: false,
                enabled: true,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: Theme.of(context).primaryColor)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(255, 255, 255, 100.0),
                  contentPadding: EdgeInsets.only(left: 20.0),
                  hintText: 'Type here',
                ),
                autofocus: true,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(
                  Icons.check,
                  size: 40.0,
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  print("KeyboardText ${_textController.text}");
                  _handleSubmitted(_textController.text);
                  widget.onSubmit(_textController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
