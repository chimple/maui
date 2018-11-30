import 'dart:async';
import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:maui/db/entity/home.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/repos/home_page_repo.dart';
import 'package:maui/loca.dart';
import 'package:maui/screens/comment_list_view.dart';
import 'package:maui/repos/likes_repo.dart';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => new _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with TickerProviderStateMixin {
  AnimationController _commentButtonAnimationController;
  List<Home> _home = [];
  List<int> _likes = [];
  List<User> _allUsers = [];
  bool _isLoading;
  User _loggedInUser;
  void _initHomeData() async {
    setState(() => _isLoading = true);
    _home = await HomeRepo().getHomeTiles();
    _initUserData();
    _initLikeData();
  }

  void _initLikeData() async {
    for (var tile in _home) {
      _likes.add(await LikesRepo().getNumberOfLikesByTileId(tile.tileId));
    }
    setState(() => _isLoading = false);
  }

  void _initUserData() async {
    for (var tile in _home) {
      _allUsers.add(await UserRepo().getUser(tile.userId));
    }
  }

  Future<Null> _startAnimation() async {
    try {
      print(":");
      await _commentButtonAnimationController.reverse().orCancel;
      print("forward");
      // await _commentButtonAnimationController.forward().orCancel;
      print("reversed");
    } on TickerCanceled {}
  }

  Widget _initTileData(String type, String typeId) {
    return new Container(
      color: type == "quiz"
          ? Colors.red
          : type == "article" ? Colors.green : Colors.grey,
      height: 400.0,
      width: 400.0,
      child: new Center(
        child: new Text(
          "$typeId" + " " + "$type",
          style: new TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _commentButtonAnimationController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _commentButtonAnimationController.forward();
  }

  @override
  void didUpdateWidget(HomePageView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget != this.widget) {
      _commentButtonAnimationController.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initHomeData();
  }

  Widget _homeTiles(int index) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: new ListTile(
        key: new Key(index.toString()),
        title: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Expanded(
                    flex: 1,
                    child: _allUsers[index] == null
                        ? new CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.black,
                            child: new Image.asset('assets/chat_Bot_Icon.png'),
                          )
                        : new CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.black,
                            backgroundImage: new FileImage(
                              new File(_allUsers[index].image),
                            ),
                          ),
                  ),
                  new Expanded(
                    flex: 10,
                    child: _allUsers[index] == null
                        ? new Container(
                            child: new Center(
                              child: new Text(
                                "user not there",
                                style: new TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : new Container(
                            child: new Center(
                            child: new Text("${_allUsers[index].name}"),
                          )),
                  ),
                ]),
            new Padding(
              padding: const EdgeInsets.all(80.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _home[index].type == "quiz"
                      ? _initTileData(_home[index].type, _home[index].typeId)
                      : _home[index].type == "article"
                          ? _initTileData(
                              _home[index].type, _home[index].typeId)
                          : _initTileData(
                              _home[index].type, _home[index].typeId),
                ],
              ),
            ),
          ],
        ),
        subtitle: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: new RaisedButton(
                  shape: new RoundedRectangleBorder(
                      side: new BorderSide(
                          color: Colors.brown,
                          width: 1.0,
                          style: BorderStyle.solid),
                      borderRadius: new BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: new Icon(
                          Icons.thumb_up,
                          size: 30.0,
                          color: Colors.green,
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: new Text(
                          _likes[index].toString(),
                          style: new TextStyle(fontSize: 30.0),
                        ),
                      )
                    ],
                  ),
                  elevation: 5.0,
                  onPressed: () async {
                    await LikesRepo().insertOrDeleteLike(
                        _home[index].tileId, _loggedInUser.id);
                    _isLoading = true;
                    _likes.clear();
                    _initLikeData();
                  },
                ),
              ),
            ),
            new Expanded(
              flex: 2,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new GestureDetector(
                  onTap: () {
                    _startAnimation();
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new CommentListView(
                              tileId: _home[index].tileId,
                              loggedInUser: _loggedInUser,
                              tileUser: _allUsers[index],
                            );
                          },
                        ),
                      );
                    });
                  },
                  child: new AnimatedCommentBox(
                    controller: _commentButtonAnimationController,
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          _home[index].type == "quiz"
              ? print("To the Quiz")
              : _home[index].type == "article"
                  ? print("To the article")
                  : print("to the activity");
        },
        contentPadding: const EdgeInsets.all(25.0),
        isThreeLine: true,
        enabled: true,
        dense: false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _commentButtonAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loggedInUser = AppStateContainer.of(context).state.loggedInUser;
    return _isLoading
        ? new CircularProgressIndicator()
        : new RefreshIndicator(
            onRefresh: () async {
              await new Future.delayed(
                  const Duration(
                    seconds: 5,
                  ), () {
                _initHomeData();
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text(
                    " Refreshed",
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  duration: const Duration(
                    seconds: 5,
                  ),
                  backgroundColor: Colors.white,
                ));
              });
            },
            child: new ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return new Container(
                  color: Colors.grey,
                  height: 2.0,
                );
              },
              itemCount: _home.length,
              itemBuilder: (BuildContext context, int index) {
                return _homeTiles(index);
              },
            ),
          );
  }
}

class AnimatedCommentBox extends StatelessWidget {
  AnimatedCommentBox({Key key, this.controller})
      : opacity = new Tween<double>(begin: 0.0, end: 1.0).animate(
            new CurvedAnimation(
                parent: controller,
                curve: new Interval(0.0, 1.0, curve: Curves.bounceInOut))),
        radius = new Tween<double>(
          begin: 10.0,
          end: 0.0,
        ).animate(new CurvedAnimation(
            parent: controller,
            curve: new Interval(0.0, 1.0, curve: Curves.linear))),
        super(key: key);
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> radius;

  @override
  Widget build(BuildContext context) {
    //timeDilation = 2.0;
    // TODO: implement build
    return new AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return new Opacity(
          opacity: opacity.value,
          child: new Container(
              child: new Center(
                child: new Text(
                  Loca.of(context).comment,
                  style: new TextStyle(fontSize: 30.0),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.yellow,
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: new BorderRadius.circular(10.0),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    spreadRadius: radius.value,
                  )
                ],
              )),
        );
      },
    );
  }
}
