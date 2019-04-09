import 'dart:convert';
import 'dart:math';

import 'package:built_value/standard_json_plugin.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/jamaica/widgets/chat_bot.dart';
import 'package:maui/jamaica/widgets/slide_up_route.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  bool _isLoading = true;
  ChatScript _chatScript;
  Navigator _navigator;
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _navigator = Navigator(
      onGenerateRoute: (settings) => SlideUpRoute(
            widgetBuilder: (context) => _buildChatBot(context),
          ),
    );
    _loadChatScript();
  }

  _loadChatScript() async {
    final standardSerializers =
        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

    final jsonString =
        await rootBundle.loadString('assets/chat/chat_script.json');
    final json = jsonDecode(jsonString);
    setState(() {
      _isLoading = false;
      _chatScript = standardSerializers.deserialize(json);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('ChatBotScreen:build');
    if (_isLoading) {
      return Container(
        child: Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SafeArea(
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Expanded(
              child: Navigator(
                onGenerateRoute: (settings) => SlideUpRoute(
                      widgetBuilder: (context) => _buildChatBot(context),
                    ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 128.0,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBot(BuildContext context, {String choice}) {
    print('_buildChatBot');
    ChatQuestion question;
    if (choice != null) {
      final chosenChoice = _chatScript.choices[choice];
      if (chosenChoice != null && chosenChoice.questions != null) {
        final q = chosenChoice
            .questions[_random.nextInt(chosenChoice.questions.length)];
        question = _chatScript.questions[q];
      }
    }
    if (question == null) {
      question = _chatScript.questions.entries
          .elementAt(_random.nextInt(_chatScript.questions.length))
          .value;
    }
    return ChatBot(
      text: question.question,
      choices: question.choices
          .map((c) => _chatScript.choices[c].choice)
          .toList(growable: false),
      chatCallback: (String choice) => Navigator.of(context).push(SlideUpRoute(
            widgetBuilder: (context) => _buildChatBot(context, choice: choice),
          )),
    );
  }
}
