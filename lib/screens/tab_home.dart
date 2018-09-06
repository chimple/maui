import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/loca.dart';
import 'package:maui/state/app_state_container.dart';

import 'category_list_view.dart';
import 'profile_view.dart';
// import 'package:maui/story/story_list_view.dart';

class TabHome extends StatefulWidget {
  TabHome({Key key}) : super(key: key);

  @override
  TabHomeState createState() {
    return new TabHomeState();
  }
}

class TabHomeState extends State<TabHome>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final List<MyTabs> _tabs = [
    new MyTabs(
        img1: "assets/chatBig.png",
        img2: "assets/chatSmall.png",
        color: const Color(0xffFECE3D)),
    new MyTabs(
        img1: "assets/gameBig.png",
        img2: "assets/gameSmall.png",
        color: const Color(0xff36C5E4)),
  ];
  MyTabs _myHandler;
  var control = true;
  Widget _icon1 = new Container();
  Widget _icon2 = new Container();
  AnimationController _imgController, _imgController1, _bubbleController;
  ScrollController _scrollcontroller;
  Animation<double> animateImage, animateImage1;
  TabController _controller;
  void initState() {
    super.initState();
    print('TabHomeState: initState');
    WidgetsBinding.instance.addObserver(this);
    _scrollcontroller =
        new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _scrollcontroller.addListener(_scrolling);
    _bubbleController = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _imgController = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _imgController1 = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animateImage =
        new CurvedAnimation(parent: _imgController, curve: Curves.ease);
    animateImage1 =
        new CurvedAnimation(parent: _imgController1, curve: Curves.ease);
    _controller = new TabController(length: 4, vsync: this);
    _myHandler = _tabs[0];
    _controller.addListener(_tabSelected);
    // _imgController1.forward();
    _icon1 = new Image.asset(
      _myHandler.img1,
      scale: .3,
    );
  }

  void _tabSelected() {
    if (control) {
      control = false;
      new Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          control = true;
        });
      });
    }
    setState(() {
      _myHandler = _tabs[_controller.index];
      // _icon1 = new Image.asset(
      //                       '${_myHandler.img1}',
      //                       scale: .3,
      //                     );
      //  _icon2 = new Image.asset(
      //                       '${_myHandler.img2}',
      //                       scale: .3,
      //                     );

      if (_scrollcontroller.offset == 0.0) {
        // _imgController1.forward();
        // _imgController.reverse();

        _icon1 = new Image.asset(
          _myHandler.img1,
          scale: .3,
        );

        _icon2 = new Container();
      } else {
        //         _imgController1.reverse();
        // _imgController.forward();
        _icon2 = new Image.asset(
          _myHandler.img2,
          scale: .3,
        );

        _icon1 = new Container();
      }
    });
  }

  void _scrolling() {
    setState(() {
      if (_scrollcontroller.offset == 0.0) {
        _imgController1.forward();
        _imgController.reverse();

        _icon1 = new ScaleTransition(
          scale: animateImage1,
          child: new Image.asset(
            _myHandler.img1,
            scale: .3,
          ),
        );
      } else {
        _imgController1.reverse();
        _imgController.forward();
        _icon2 = new ScaleTransition(
          scale: animateImage,
          child: new Image.asset(
            _myHandler.img2,
            scale: .3,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_tabSelected);
    _controller.dispose();
    _imgController.dispose();
    _bubbleController.dispose();
    _scrollcontroller.removeListener(_scrolling);
    _scrollcontroller.dispose();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() {
    return new Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    print('TabHomeState:build');
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = media.orientation;
    var _size = media.size;
    if (user == null)
      return Container(
        color: Colors.white,
      );
    else
      return new Scaffold(
        drawer: new ProfileDrawer(),
        floatingActionButton: Container(
          height: 100.0,
          width: 100.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
        ),
        body: new NestedScrollView(
          controller: _scrollcontroller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: const Color(0xffFC5E79),
                pinned: true,
                actions: <Widget>[_icon2],
                leading: new ProfileDrawerIcon(),
                title: new Text(Loca.of(context).title),
                expandedHeight: orientation == Orientation.portrait
                    ? _size.height * .25
                    : _size.height * .5,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: new FlexibleSpaceBar(
                  background: new FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      child: _icon1),
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
                  unselectedLabelColor: _myHandler.color,
                  tabs: <Tab>[
                    new Tab(
                      text: Loca.of(context).chat,
                    ),
                    new Tab(
                      text: Loca.of(context).game,
                    ),
                    new Tab(
                      text: Loca.of(context).category,
                    ),
                    new Tab(
                      text: Loca.of(context).profile,
                    )
                  ],
                ),
              ),
            ];
          },
          body: new TabBarView(
            controller: _controller,
            children: <Widget>[new FriendListView(), new GameListView(),
            new CategoryListView(),
            new ProfileView()],
          ),
        ),
      );
  }
}


class MyTabs {
  final String img1;
  final String img2;
  final Color color;
  MyTabs({this.img1, this.img2, this.color});
}
