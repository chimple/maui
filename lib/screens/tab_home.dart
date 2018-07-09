import 'package:flutter/material.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/story/story_list_view.dart';

class TabHome extends StatefulWidget {
  final String title;

  TabHome({Key key, this.title}) : super(key: key);

  @override
  TabHomeState createState() {
    return new TabHomeState();
  }
}

class TabHomeState extends State<TabHome> with TickerProviderStateMixin {
  final List<MyTabs> _tabs = [
    new MyTabs(img: "assets/chat.png", color: Colors.teal[200]),
    new MyTabs(img: "assets/games.png", color: Colors.orange[200])
  ];
  MyTabs _myHandler;
  TabController _controller;
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _myHandler = _tabs[0];
    _controller.addListener(_handleSelected);
  }

  void _handleSelected() {
    setState(() {
      _myHandler = _tabs[_controller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var _size = media.size;
    return new Scaffold(
          drawer: new ProfileDrawer(),
          floatingActionButton: new FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed('/chatbot'),
              child: new Image.asset('assets/koala_neutral.png')),
          body: new NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  backgroundColor: _myHandler.color,
                  pinned: true,
                  leading: new ProfileDrawerIcon(),
                  title: new Text("Maui"),
                  expandedHeight: _size.height * .3,
                  // title: const Text('Maui App Testing'),
                  // centerTitle: true,
                  forceElevated: innerBoxIsScrolled,
                  // floating: true,
                  flexibleSpace: new FlexibleSpaceBar(
                    background: new FittedBox(
                      child: new Image.asset(
                        '${_myHandler.img}',
                        scale: .3,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  bottom: new TabBar(
                    controller: _controller,
                    unselectedLabelColor: Colors.blue,
                    tabs: <Tab>[
                      new Tab(text: 'Chat'),
                      new Tab(text: 'Game')
                    ],
                  ),
                ),
              ];
            },
            body: new TabBarView(
              controller: _controller,
              children: <Widget>[new FriendListView(), new GameListView()],
            ),
          ),
        );
  }
}

class MyTabs {
  final String img;
  final Color color;
  MyTabs({this.img, this.color});
}
