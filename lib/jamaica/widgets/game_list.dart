import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/lesson.dart';
import 'package:maui/jamaica/models/app_state.dart';
import 'package:maui/repos/lesson_repo.dart';

enum _ButtonStatus { active, disabled }

class GameList extends StatefulWidget {
  @override
  GameListState createState() {
    return new GameListState();
  }
}

class GameListState extends State<GameList>
    with SingleTickerProviderStateMixin {
  String gameToOpen = '';

  bool isComplete = false;
  TabController _tabController;
  bool isLoading = true;
  List<List<Lesson>> data;
  BuiltMap<String, int> userData;

  ScrollController _scrollController;
  double width;

  @override
  void initState() {
    super.initState();
    initFn();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_tabListener);
    _scrollController = ScrollController();
  }

  initFn() async {
    setState(() => isLoading = true);
    data = [];
    userData = AppState.loading().userProfile.lessons;
    data.add(await LessonRepo().getLessonsByTopic(TopicType.math));
    data.add(await LessonRepo().getLessonsByTopic(TopicType.reading));
    double scrollOffset = _calcCurrentLessonIndex(data[0]) * (width * .7) / 2.1;
    _scrollController = ScrollController(initialScrollOffset: scrollOffset);
    setState(() => isLoading = false);
  }

  _tabListener() {
    double scrollOffset = _calcCurrentLessonIndex(data[_tabController.index]) *
        (width * .7) /
        2.1;
    _scrollController.animateTo(scrollOffset,
        duration: new Duration(seconds: 2), curve: Curves.easeOutExpo);
  }

  int _calcCurrentLessonIndex(data) {
    int i = 0;
    while (i < data.length) {
      if (userData.containsKey(data[i].title) &&
          !userData.containsKey(data[i + 1].title)) {
        break;
      }
      i++;
    }
    if (i == data.length)
      return 0;
    else
      return i;
  }

  void _onTap(String title) {
    setState(() {
      gameToOpen = title;
    });
  }

  void _flareCallback(String animationNme) {
    setState(() {
      isComplete = true;
    });

    // List gamelevel = [];
    // for (int i = 1; i <= gameConfig.levels; i++) {
    //   gamelevel.add(i);
    // }

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return GameLevel(
    //         gameName: gameToOpen,
    //         levelList: gamelevel,
    //         gameImage: gameConfig.image,
    //       );
    //     }).then((onValue) => setState(() {
    //       gameToOpen = '';
    //       isComplete = false;
    //     }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget tabBarView(data, MediaQueryData media, bool _isPortrait) {
    final List<Lesson> temp = data;
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: temp
          .map((t) => FractionallySizedBox(
              widthFactor: .7,
              child: GameButton(
                title: t.title,
                progress: userData.containsKey(t.title) ? userData[t.title] : 0,
                locked: !userData.containsKey(t.title),
                onTap: _onTap,
                flareCallback: _flareCallback,
                animationFlag: t.title == gameToOpen,
                buttonStatus: gameToOpen != ''
                    ? _ButtonStatus.disabled
                    : _ButtonStatus.active,
              )))
          .toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final double height = media.size.height;
    width = media.size.width;
    final _isPortrait = width < height;

    if (isLoading)
      return Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: Stack(alignment: Alignment.center, children: [
        Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: data
                      .map((f) => tabBarView(f, media, _isPortrait))
                      .toList()),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: _isPortrait ? height * .1 : height * .18,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange[400], Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: TabBar(
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    indicatorWeight: 4,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.menu),
                        text: 'Reading',
                      ),
                      Tab(
                        icon: Icon(Icons.access_time),
                        text: 'Math',
                      ),
                    ],
                    controller: _tabController,
                  )),
            ),
          ],
        )
      ]),
    );
  }
}

class GameButton extends StatelessWidget {
  final String title;
  final void Function(String) onTap;
  final bool animationFlag;
  final void Function(String) flareCallback;
  final _ButtonStatus buttonStatus;
  final int progress;
  final bool locked;

  const GameButton(
      {Key key,
      this.title,
      this.onTap,
      this.locked,
      this.progress,
      this.animationFlag,
      this.buttonStatus,
      this.flareCallback})
      : super(key: key);

  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final iconSize = max(media.size.width, media.size.height) / 44;

    return AspectRatio(
      aspectRatio: 2.1,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.grey[300],
        onTap: (buttonStatus == _ButtonStatus.active && !locked)
            ? () => onTap(title)
            : () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.all(media.size.width * .03),
          child: Opacity(
            opacity: locked ? 0.6 : 1,
            child: Material(
              shadowColor: Colors.white70,
              color: Colors.transparent,
              elevation: 8.0,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(16.0)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange[400], Colors.white],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FlareActor("assets/character/button.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          callback: flareCallback,
                          isPaused: !animationFlag,
                          animation: animationFlag ? "happy" : "idle"),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(title,
                                  maxLines: 2,
                                  // Text(Loca.of(context).intl(gameConfig.name),
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: iconSize,
                                      color: Colors.deepOrange),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Text(
                            'Progress',
                            style: TextStyle(color: Colors.red),
                          ),
                          LinearProgressIndicator(
                            value: progress / 99,
                          ),
                          Divider(
                            color: Colors.transparent,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
