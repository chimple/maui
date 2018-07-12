import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/loca.dart';
// import 'package:maui/story/story_list_view.dart';

class TabHome extends StatefulWidget {

  TabHome({Key key}) : super(key: key);

  @override
  TabHomeState createState() {
    return new TabHomeState();
  }
}

class TabHomeState extends State<TabHome> with TickerProviderStateMixin {
  final List<MyTabs> _tabs = [
    new MyTabs(img: "assets/chat.png", color: Colors.teal[200]),
    new MyTabs(img: "assets/games.png", color: Colors.orange[200]),
  ];
  MyTabs _myHandler;
  Widget _icon = new Container();
  Widget _icon1 = new Container();
  AnimationController _imgController, _imgController1, _bubbleController;
  ScrollController _scrollcontroller;
  Animation<double> animateImage, animateImage1;
  TabController _controller;
  void initState() {
    super.initState();
    _scrollcontroller = new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
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
    _controller = new TabController(length: 2, vsync: this);
    _myHandler = _tabs[0];
    _controller.addListener(_tabSelected);
    _icon1 = new Image.asset(
                            '${_myHandler.img}',
                            scale: .3,
                          );
  }

  void _tabSelected() {
    setState(() {
      _myHandler = _tabs[_controller.index];
    });
  }

  void _scrolling(){
    setState(() {
          if(_scrollcontroller.offset == 0.0){
            // _icon = new Container();
            _imgController1.forward();
            _imgController.reverse();
            
            _icon1 = new ScaleTransition(
              scale: animateImage1,
                          child: new Image.asset(
                            '${_myHandler.img}',
                            scale: .3,
                          ),
            );
          }
          else{
            _imgController1.reverse();
    _imgController.forward();
            _icon = new ScaleTransition(
                scale: animateImage,
                          child: new ShowIcon(
                      color: _myHandler.color,
                      img: _myHandler.img,
                    ),
            );
          }
        });
    // _icon = new ShowIcon(
    //                 color: _myHandler.color,
    //                 img: _myHandler.img,
    //               );
    // print("object");
    // print(_scrollcontroller.offset);
    
  }

  buildCircle(double delay) {
    return new ScaleTransition(
      scale: new TestTween(begin: .85, end: 1.5, delay: delay)
          .animate(_bubbleController),
      child: new Container(
        height: 30.0,
        width: 30.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.removeListener(_tabSelected);
    _controller.dispose();
    _imgController.dispose();
    _bubbleController.dispose();
    _scrollcontroller.removeListener(_scrolling);
    _scrollcontroller.dispose();
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
        controller: _scrollcontroller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              backgroundColor: _myHandler.color,
              pinned: true,
              actions: <Widget>[
                _icon
              ],
              leading: new ProfileDrawerIcon(),
              title: new Text(Loca.of(context).title),
              expandedHeight: _size.height * .3,
              // centerTitle: true,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: new FlexibleSpaceBar(
                background: (_controller.indexIsChanging == true)
                    ? new Container(
                        width: 100.0,
                        height: 50.0,
                        color: Colors.black,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCircle(.0),
                            buildCircle(.2),
                            buildCircle(.4),
                          ],
                        ),
                      )
                    : new FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        child: _icon1
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
                  new Tab(
                    text: Loca.of(context).chat,
                  ),
                  new Tab(
                    text: Loca.of(context).game,
                  )
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

class ShowIcon extends StatelessWidget {
  ShowIcon({
    Key key,
    Animation<double> animation,
    AnimationController controller,
    this.color,
    this.img,
  }) : super(key: key);

  final Color color;
  final String img;
  @override
  Widget build(BuildContext context) {
    // return new Container(
    //   // height: 10.0,
    //   width: 60.0,
    //   child: new Image.asset(
    //                       img,
    //                       scale: .8,
    //                     ),
    //   // new Image(
    //   //     image: AssetImage(img),
    //   //     fit: BoxFit.fill,
    //   //   ),
    //   decoration: new BoxDecoration(
    //     // color:  color,
    //     shape: BoxShape.circle,
    //   ),
    // );
    return new Image.asset(
                          img,
                          scale: .3,
                        );  }
}

class MyTabs {
  final String img;
  final Color color;
  MyTabs({this.img, this.color});
}

class TestTween extends Tween<double> {
  final double delay;

  TestTween({double begin, double end, this.delay})
      : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((sin((t - delay) * 2 * PI) + 1) / 2);
  }
}


