import 'dart:convert';
import 'dart:math';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/models/chat_script.dart';
import 'package:maui/models/quiz_join.dart';
import 'package:maui/models/quiz_session.dart';
import 'package:maui/models/quiz_update.dart';
import 'package:maui/models/serializers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/jamaica/widgets/quiz_game.dart';
import 'package:flutter/services.dart';
import 'package:maui/jamaica/widgets/chat_bot.dart';
import 'package:maui/jamaica/widgets/quiz_game.dart';
import 'package:maui/jamaica/widgets/slide_up_route.dart';
import 'package:maui/screens/quiz_waiting_screen.dart';
import 'package:maui/state/app_state_container.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  bool _quizJoined = false;
  Navigator _navigator;
  ChatScript _chatScript;
  String _emotion = 'idle';
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _quizJoined = false;
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

  void showAlertDialog(QuizSession quizSession) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(quizSession.title),
          content: new Text("JOIN QUIZ..!!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                //Navigator.of(context).pushNamed('/quizWaitingScreen');
                _quizJoined = true;
                AppStateContainer.of(context)
                    .joinQuizSession(quizSession)
                    .then((_) {
                  Navigator.of(context).push(MaterialPageRoute<Null>(
                      builder: (BuildContext context) =>
                          QuizWaitingScreen(quizSession: quizSession)));
                });
              },
            ),
            new FlatButton(
              child: new Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_quizJoined) {
      AppStateContainer.of(context)
          .quizSessions
          .forEach((quizSession, quizStatus) {
        if (quizStatus == StatusEnum.create) {
          showAlertDialog(quizSession);
        }
      });
    }
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
    final quizSession = StateContainer.of(context).quizSession;
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    // final userName = StateContainer.of(context).state.userProfile.name;
    final userName = AppStateContainer.of(context).state.loggedInUser.name;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.cyan,
        body: quizSession == null
            ? SafeArea(
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: <Widget>[
                    Expanded(
                      child: _navigator,
                    ),
                    Flexible(
                      child: Hero(
                        tag: 'chimp',
                        child: FlareActor(
                          "assets/character/chimp_ik.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: _emotion,
                          callback: (String name) =>
                              setState(() => _emotion = 'idle'),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: media.orientation ==
                                                    Orientation.portrait
                                                ? size.width * 0.104
                                                : size.width * 0.062,
                                            width: media.orientation ==
                                                    Orientation.portrait
                                                ? size.width * 0.285
                                                : size.width * 0.170,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: media.orientation ==
                                                          Orientation.portrait
                                                      ? size.width * 0.0064
                                                      : size.width * 0.005),
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              color: Colors.black12,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              '/jam_profile');
                                                    },
                                                    child: CircleAvatar(
                                                      child: new Container(
                                                          height: media
                                                                      .orientation ==
                                                                  Orientation
                                                                      .portrait
                                                              ? size.width *
                                                                  0.204
                                                              : size.width *
                                                                  0.12,
                                                          width: media.orientation ==
                                                                  Orientation
                                                                      .portrait
                                                              ? size.width *
                                                                  0.204
                                                              : size.width *
                                                                  0.12,
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width: media.orientation == Orientation.portrait
                                                                          ? size.width *
                                                                              0.0064
                                                                          : size.width *
                                                                              0.005),
                                                                  borderRadius:
                                                                      BorderRadius.circular(150.0), // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(170, 200))),
                                                                  color: Colors.black12,
                                                                  image: DecorationImage(
                                                                    image: ExactAssetImage(
                                                                        "assets/home_screen_icons/profile_pic.png"),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ))),
                                                      radius:
                                                          media.orientation ==
                                                                  Orientation
                                                                      .portrait
                                                              ? size.width *
                                                                  0.051
                                                              : size.width *
                                                                  0.03,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    '$userName',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          media.orientation ==
                                                                  Orientation
                                                                      .portrait
                                                              ? size.width *
                                                                  0.034
                                                              : size.width *
                                                                  0.02,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.red,
                                                        size:
                                                            media.orientation ==
                                                                    Orientation
                                                                        .portrait
                                                                ? size.width *
                                                                    0.045
                                                                : size.width *
                                                                    0.0283,
                                                      ),
                                                      Text(
                                                        '1000',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: media
                                                                        .orientation ==
                                                                    Orientation
                                                                        .portrait
                                                                ? size.width *
                                                                    0.034
                                                                : size.width *
                                                                    0.02),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        0,
                                        media.orientation ==
                                                Orientation.portrait
                                            ? size.width * 0.2
                                            : size.width * 0.32,
                                        0),
                                    child: Text('Profile',
                                        style: TextStyle(
                                            fontSize: media.orientation ==
                                                    Orientation.portrait
                                                ? size.width * 0.025
                                                : size.width * 0.015)),
                                  ),
                                ],
                              ),
                            )),
                        Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/jam_games');
                                    },
                                    child: Container(
                                        height: media.orientation ==
                                                Orientation.portrait
                                            ? size.width * 0.1
                                            : size.width * 0.06,
                                        width: media.orientation ==
                                                Orientation.portrait
                                            ? size.width * 0.1
                                            : size.width * 0.06,
                                        child: SvgPicture.asset(
                                            'assets/home_screen_icons/games.svg')),
                                  ),
                                  Text('Games',
                                      style: TextStyle(
                                          fontSize: media.orientation ==
                                                  Orientation.portrait
                                              ? size.width * 0.025
                                              : size.width * 0.015))
                                ],
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/stories');
                                    },
                                    child: Container(
                                        height: media.orientation ==
                                                Orientation.portrait
                                            ? size.width * 0.1
                                            : size.width * 0.06,
                                        width: media.orientation ==
                                                Orientation.portrait
                                            ? size.width * 0.1
                                            : size.width * 0.06,
                                        child: SvgPicture.asset(
                                            'assets/home_screen_icons/story.svg')),
                                  ),
                                  Text(
                                    'Stories',
                                    style: TextStyle(
                                        fontSize: media.orientation ==
                                                Orientation.portrait
                                            ? size.width * 0.025
                                            : size.width * 0.015),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/jam_map');
                                    },
                                    child: Container(
                                        height: media.orientation ==
                                                Orientation.portrait
                                            ? size.width * 0.1
                                            : size.width * 0.06,
                                        width: media.orientation ==
                                                Orientation.portrait
                                            ? size.width * 0.1
                                            : size.width * 0.06,
                                        child: SvgPicture.asset(
                                            'assets/home_screen_icons/map.svg')),
                                  ),
                                  Text('Map',
                                      style: TextStyle(
                                          fontSize: media.orientation ==
                                                  Orientation.portrait
                                              ? size.width * 0.025
                                              : size.width * 0.015))
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : AlertDialog(
                title: new Text("Quiz  to Start student"),
                content: RaisedButton(
                    onPressed: () {
                      final standardSerializers = (serializers.toBuilder()
                            ..addPlugin(StandardJsonPlugin()))
                          .build();

                      final quizSession =
                          StateContainer.of(context).quizSession;
                      final studentId = StateContainer.of(context).studentIdVal;

                      QuizJoin quizJoin = QuizJoin((d) => d
                        ..sessionId = quizSession.sessionId
                        ..studentId = studentId);

                      final jsonquizJoin =
                          standardSerializers.serialize(quizJoin);
                      final jsonquizJoinString = jsonEncode(jsonquizJoin);
                      print(jsonquizJoinString);
                      print(".......object is.....$quizJoin");
                      final endPointId =
                          StateContainer.of(context).quizSessionEndPointId;
                      StateContainer.of(context)
                          .sendMessageTo(endPointId, jsonquizJoinString);

                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (ctxt) => new QuizGame(
                                  quizSession: quizSession,
                                )),
                      );
                    },
                    child: new Text("Yes, Ready To Play")),
              ));
  }

  Widget _buildChatBot(BuildContext context, {String choice}) {
    print('_buildChatBot');
    final question = getChatQuestion(input: choice);
    return ChatBot(
      text: question.question,
      choices: question.choices
          .map((c) => _chatScript.choices[c].choice)
          .toList(growable: false),
      chatCallback: (String choice) {
        setState(() {
          _emotion = 'happy';
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.of(context).push(SlideUpRoute(
            widgetBuilder: (context) => _buildChatBot(context, choice: choice),
          ));
        });
      },
    );
  }

  ChatQuestion getChatQuestion({String input}) {
    ChatQuestion question;
    if (input != null) {
      final chosenChoice = _chatScript.choices[input];
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
    return question;
  }
}
