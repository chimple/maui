import 'dart:async';
import 'dart:io';
import 'package:maui/db/entity/home.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/screens/drawing_list_screen.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/repos/home_page_repo.dart';
import 'package:maui/screens/comment_list_view.dart';
import 'package:maui/repos/likes_repo.dart';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => new _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initHomeData();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   _initHomeData();
  // }

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
                        ? new Container(
                            decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(40.0),
                                border: new Border.all(
                                    width: 3.0, color: Colors.black)),
                            child: new CircleAvatar(
                              backgroundColor: Colors.white,
                              child:
                                  new Image.asset('assets/chat_Bot_Icon.png'),
                            ),
                          )
                        : new Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(40.0),
                              border: new Border.all(
                                  width: 3.0, color: Colors.black),
                            ),
                            child: new CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: new FileImage(
                                new File(_allUsers[index].image),
                              ),
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
                      ? new Container(
                          color: Colors.brown,
                          height: 200.0,
                          width: 200.0,
                          child: new Text("quiz"),
                        )
                      : _home[index].type == "article"
                          ? new Container(
                              color: Colors.red,
                              height: 200.0,
                              width: 200.0,
                              child: new Text("article"),
                            )
                          : new Container(
                              color: Colors.green,
                              height: 200.0,
                              width: 200.0,
                              child: new Text("Activity"),
                            ),
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
                    print("liked");
                  },
                ),
              ),
            ),
            new Expanded(
              flex: 2,
              child: new RaisedButton(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                shape: new RoundedRectangleBorder(
                    side: new BorderSide(
                        color: Colors.brown,
                        width: 1.0,
                        style: BorderStyle.solid),
                    borderRadius: new BorderRadius.circular(20.0)),
                elevation: 5.0,
                onPressed: () {
                  print("objectffff");
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new CommentListView(
                          tileId: _home[index].tileId,
                          loggedInUser: _loggedInUser,
                        );
                      },
                    ),
                  );
                },
                child: new Text(
                  "Comment",
                  style: new TextStyle(fontSize: 30.0),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          _home[index].type == "quiz"
              ? print("vfn aayush agrawal")
              : _home[index].type == "article"
                  ? print("jhvfkbvgvbkbgkbrgkbg")
                  : Navigator.of(context).push(new MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                      return DrawingListScreen(
                        activityId: _home[index].typeId,
                      );
                    }));
        },
        contentPadding: const EdgeInsets.all(25.0),
        isThreeLine: true,
        enabled: true,
        dense: false,
      ),
    );
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
