import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/loca.dart';
// import 'package:maui/story/story_list_view.dart';

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
  ];
  MyTabs _myHandler;
  AnimationController _imgController, _bubbleController;
  Animation<double> animateImage;
  TabController _controller;
  void initState() {
    super.initState();
    _bubbleController = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _imgController = new AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    animateImage =
        new CurvedAnimation(parent: _imgController, curve: Curves.bounceInOut);
    _controller = new TabController(length: 2, vsync: this);
    _myHandler = _tabs[0];
    _controller.addListener(_handleSelected);
    _imgController.forward();
  }

  void _handleSelected() {
    setState(() {
      _myHandler = _tabs[_controller.index];
    });
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
    _controller.removeListener(_handleSelected);
    _controller.dispose();
    _imgController.dispose();
    _bubbleController.dispose();
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
            new SliverAppBar(
              backgroundColor: _myHandler.color,
              pinned: true,
              actions: <Widget>[
                new AnimatedTabIcon(
                  color: _myHandler.color,
                  img: _myHandler.img,
                  animation: animateImage,
                ),
              ],
              leading: new ProfileDrawerIcon(),
              title: new Text(widget.title),
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

class AnimatedTabIcon extends AnimatedWidget {
  AnimatedTabIcon({
    Key key,
    Animation<double> animation,
    AnimationController controller,
    this.color,
    this.img,
  }) : super(key: key, listenable: animation);

  final Color color;
  final String img;
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      // height: 10.0,
      width: 60.0,
      child: new ScaleTransition(
        scale: animation,
        child: new Image(
          image: AssetImage(img),
          fit: BoxFit.fill,
        ),
      ),
      decoration: new BoxDecoration(
        // color:  color,
        shape: BoxShape.circle,
      ),
    );
  }
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

// class TabIcon extends StatelessWidget {
//   final String img;
//   final Color color;
//   final bool flag;
//   TabIcon({this.img, this.color, this.flag});

//   @override
//   Widget build(BuildContext context) {

//     return flag ? new Container(
//       // height: 10.0,
//       width: 60.0,
//       decoration: new BoxDecoration(
//         color:  Colors.red,
//         shape: BoxShape.circle,
//       ),
//     ) : new Container();
//   }
// }
