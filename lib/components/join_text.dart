import 'package:flutter/material.dart';
import 'package:maui/screens/chat_bot_screen.dart';
import 'package:maui/state/app_state_container.dart';

class JoinText extends StatefulWidget {
  Function onSubmit;
  String answer;
  List<String> choices;
  JoinText({this.answer, this.choices, this.onSubmit});

  @override
  JoinTextState createState() {
    return new JoinTextState();
  }
}

class JoinTextState extends State<JoinText> {
  List<String> displayChoices;
  List<String> chosenChoices;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    print('${widget.answer} ${widget.choices}');
    chosenChoices = [];
    displayChoices = List.from(widget.choices);
    if (widget.answer != null) {
      displayChoices.add(widget.answer);
    }
    displayChoices.shuffle();
  }

  @override
  void didUpdateWidget(JoinText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.answer != oldWidget.answer ||
        widget.choices != oldWidget.choices) {
      _initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;

    return widget.answer == null
        ? Container()
        : new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Wrap(
                            spacing: 8.0,
                            children: chosenChoices
                                .map((c) => new RaisedButton(
                                    onPressed: () => moveFromChosenToDisplay(c),
                                    child: new Text(c)))
                                .toList(growable: false))),
                    new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: () => widget.onSubmit(new ChatItem(
                            sender: user.id,
                            chatItemType: ChatItemType.text,
                            content: chosenChoices.join())))
                  ],
                ),
                new Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: displayChoices
                        .map((c) => new RaisedButton(
                            onPressed: () => moveFromDisplayToChosen(c),
                            child: new Text(c)))
                        .toList(growable: false))
              ],
            ));
  }

  void moveFromDisplayToChosen(String s) {
    setState(() {
      displayChoices.remove(s);
      chosenChoices.add(s);
    });
  }

  void moveFromChosenToDisplay(String s) {
    setState(() {
      chosenChoices.remove(s);
      displayChoices.add(s);
    });
  }
}
