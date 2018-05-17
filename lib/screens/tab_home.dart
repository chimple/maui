import 'package:flutter/material.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/story/story_list_view.dart';

class TabHome extends StatelessWidget {
  final String title;

  TabHome({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
          drawer: new ProfileDrawer(),
          floatingActionButton: new FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed('/chatbot'),
              child: new Image.asset('assets/koala_neutral.png')),
          body: new NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  backgroundColor: Colors.red,
                  pinned: true,
                  expandedHeight: 300.0,
                  // title: const Text('Maui App Testing'),
                  // centerTitle: true,
                  forceElevated: innerBoxIsScrolled,
                  // floating: true,
                  flexibleSpace: new FlexibleSpaceBar(
                    background: new Image.asset(
                      'assets/hoodie/drawing.png',
                      scale: .85,
                    ),
                    centerTitle: true,
                  ),
                  bottom: new TabBar(
                    unselectedLabelColor: Colors.black,
                    tabs: <Widget>[
                      new Tab(text: 'Chat', icon: new Icon(Icons.chat)),
                      new Tab(text: 'Game', icon: new Icon(Icons.games)),
                      new Tab(text: 'Story', icon: new Icon(Icons.book))
                    ],
                  ),
                ),
              ];
            },
            body: new TabBarView(
              children: <Widget>[
                new FriendListView(),
                new GameListView(),
                new StoryListView()
              ],
            ),
          ),
        ));
  }
}
