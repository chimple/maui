import 'package:flutter/material.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/story/story_list_view.dart';
import 'package:maui/loca.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

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
    new MyTabs(img: "assets/games.png", color: Colors.orange[200]),
    new MyTabs(img: "", color: Colors.black)
  ];
  Animation<double> imageAnimation;
  AnimationController imageController;
  MyTabs _myHandler;
  TabController _controller;
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _myHandler = _tabs[0];
    _controller.addListener(_handleSelected);
    // _controller.indexIsChanging;
    // _controller.notifyListeners();
    // imageController = new AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    // imageAnimation = new CurvedAnimation(parent: imageController, curve: Curves.bounceInOut);
    //   imageController.forward();
  }

  void _handleSelected() {
    setState(() {
      if (_controller.indexIsChanging) {
        _myHandler = _tabs[2];
      } else {
        _myHandler = _tabs[_controller.index];
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.removeListener(_handleSelected);
    _controller.dispose();
    // imageController.dispose();
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
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // new SliverList(),

            new SliverAppBar(
              backgroundColor: _myHandler.color,
              pinned: true,
              leading: new ProfileDrawerIcon(),
              title: new Text(Loca.of(context).title),
              expandedHeight: _size.height * .3,
              // centerTitle: true,
              forceElevated: true,
              flexibleSpace: new FlexibleSpaceBar(
                background: new FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  child: new Image.asset(
                    '${_myHandler.img}',
                    scale: .3,
                  ),
                ),
                // centerTitle: true,
              ),
              bottom: new TabBar(
                isScrollable: false,
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5.0,
                labelColor: Colors.white,
                labelStyle: new TextStyle(
                    fontSize: _size.height * 0.3 * 0.07,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                controller: _controller,
                unselectedLabelColor: Colors.blue,
                tabs: <Tab>[
                  new Tab(text: Loca.of(context).chat),
                  new Tab(text: Loca.of(context).game)
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
