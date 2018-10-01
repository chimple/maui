import 'dart:async';
import 'dart:io';
import 'package:maui/db/entity/home.dart';
import 'package:maui/db/entity/user.dart';
// import 'package:maui/repos/quiz_repo.dart';
import 'package:maui/repos/user_repo.dart';
// import 'package:maui/repos/activity_repo.dart';
// import 'package:maui/repos/article_repo.dart';
import 'package:maui/repos/home_page_repo.dart';
import 'package:maui/repos/comments_repo.dart';
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
  List<User> _users = [];
  bool _isLoading;
  User _user;
  void _initHomeData() async {
    setState(() => _isLoading = true);
    // _user = AppStateContainer.of(context).state.loggedInUser;
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
      _users.add(await UserRepo().getUser(tile.userId));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
                    child: _users[index] == null
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
                                new File(_users[index].image),
                              ),
                            ),
                          ),
                  ),
                  new Expanded(
                    flex: 10,
                    child: _users[index] == null
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
                            child: new Text("${_users[index].name}"),
                          )),
                  ),
                ]),
            new Padding(
              padding: const EdgeInsets.all(80.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Expanded(
                    flex: 1,
                    child: new Icon(
                      Icons.airport_shuttle,
                      size: 50.0,
                      semanticLabel: "just testing",
                    ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Icon(
                      Icons.access_alarm,
                      size: 50.0,
                      semanticLabel: "just testing",
                    ),
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
                    await LikesRepo()
                        .insertOrDeleteLike(_home[index].tileId, _user.id);
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
                  onPressed: () async {
                    String timeStamp =
                        (new DateTime.now().millisecondsSinceEpoch).toString();
                    await CommentsRepo().insertAComment(_home[index].tileId,
                        timeStamp, _user.id, "Hi i am testing comment");
                    print("comment added");
                  },
                  child: new Text(
                    "Comment",
                    style: new TextStyle(fontSize: 30.0),
                  )),
            ),
          ],
        ),

        // onTap: null,
        contentPadding: const EdgeInsets.all(25.0),
        isThreeLine: true,
        enabled: true,
        dense: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _user = AppStateContainer.of(context).state.loggedInUser;
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
