import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

typedef void ChatCallback(String text);

class ChatBot extends StatelessWidget {
  final String text;
  final List<String> choices;
  final ChatCallback chatCallback;

  const ChatBot({Key key, this.text, this.choices, this.chatCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor =
        themeColors[AppStateContainer.of(context).userProfile.currentTheme];
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: themeColor, borderRadius: BorderRadius.circular(24.0)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .merge(TextStyle(color: Colors.white)),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment(-1, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: choices
                    .map(
                      (c) => Padding(
                            padding: EdgeInsets.all(8.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              color: Colors.white,
                              child: Text(
                                c,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .merge(TextStyle(color: themeColor)),
                              ),
                              onPressed: () => chatCallback(c),
                            ),
                          ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        )
      ],
    );
  }
}
