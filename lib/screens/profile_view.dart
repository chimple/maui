import 'dart:io';
import '../loca.dart';
import 'package:flutter/material.dart';
import '../state/app_state_container.dart';
import 'topic_view.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  List<String> categories = [
    "gallery",
    "topic",
  ];
  TabController _controller;

  @override
  void initState() {
    super.initState();
    print("Welcome to QuizProgressTracker class");
    _controller = new TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext ctxt) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = media.orientation;
    var _size = media.size;
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new Scaffold(
      body: new NestedScrollView(
        // controller: _scrollcontroller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              backgroundColor: const Color(0xffFC5E79),
              pinned: true,

              expandedHeight: orientation == Orientation.portrait
                  ? _size.height * .25
                  : _size.height * .5,
              // forceElevated:false,
              flexibleSpace: new FlexibleSpaceBar(
                background: new FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  child: Container(
                    height: 300.0,
                    width: 300.0,
                    child: new Center(
                        child: Column(children: [
                      new Container(
                        height: 200.0,
                        width: 200.0,
                        decoration: new BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(16.0)),
                        ),
                        child: Image.file(new File(user.image)),
                      ),
                      new Text("${user.name}")
                    ])),
                  ),
                ),
              ),
              bottom: new TabBar(
                isScrollable: false,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5.0,
                labelColor: Colors.white,
                labelStyle: new TextStyle(
                    fontSize: _size.height * 0.3 * 0.07,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                controller: _controller,
                // unselectedLabelColor: _myHandler.color,
                tabs: <Tab>[
                  new Tab(
                    text: Loca.of(context).gallery,
                  ),
                  new Tab(
                    text: Loca.of(context).topic,
                  ),
                ],
              ),
            ),
          ];
        },
        body: new TabBarView(
          controller: _controller,
          children: <Widget>[
            new Text("i have to show gallery here"),
            new TopicView(),
          ],
        ),
      ),
    );
  }
}
