import 'package:flutter/material.dart';
import 'dart:io';
import 'package:maui/db/entity/comments.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/comments_repo.dart';
import 'package:maui/repos/user_repo.dart';

class CommentListView extends StatefulWidget {
  final User loggedInUser;
  final String tileId;
  const CommentListView({Key key, this.loggedInUser, this.tileId})
      : super(key: key);
  @override
  _CommentListViewState createState() => new _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView> {
  final FocusNode myFocusNode = FocusNode();
  List<Comments> _comments = [];
  List<User> _allUsers = [];
  bool _isLoading = true;

  TextEditingController _textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = new TextEditingController();
    // _initCommentData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _initCommentData();
  }

  void _initCommentData() async {
    setState(() => _isLoading = true);
    _comments = await CommentsRepo().getCommentsByTileId(widget.tileId);
    if (_comments != null) {
      _initUserData();
    }
    print(_allUsers);
    print(_comments);
    setState(() => _isLoading = false);
  }

  void _initUserData() async {
    for (var comment in _comments) {
      _allUsers.add(await UserRepo().getUser(comment.commentingUserId));
    }
  }

  Widget _buildCommentTile(int index) {
    return new Container(
      child: new Row(
        children: [
          new Expanded(
            flex: 1,
            child: _allUsers[index] == null
                ? new Container(
                    decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(40.0),
                        border:
                            new Border.all(width: 3.0, color: Colors.black)),
                    child: new CircleAvatar(
                      backgroundColor: Colors.white,
                      child: new Image.asset('assets/chat_Bot_Icon.png'),
                    ),
                  )
                : new Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(40.0),
                      border: new Border.all(width: 3.0, color: Colors.black),
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
            flex: 8,
            child: new Container(
              child: new Center(
                child: Text(
                  _comments[index].comment,
                  softWrap: true,
                ),
              ),
            ),
          ),
          (widget.loggedInUser.id == _comments[index].commentingUserId)
              ? new Expanded(
                  flex: 1,
                  child: new DropdownButton(
                    key: new Key(
                      index.toString(),
                    ),
                    hint: new Text("options"),
                    onChanged: (value) async {
                      if (value == "delete") {
                        await CommentsRepo().deleteAComment(
                            _comments[index].tileId,
                            _comments[index].timeStamp,
                            _comments[index].commentingUserId,
                            _comments[index].comment);
                        setState(() => _isLoading = true);
                        _initCommentData();
                      } else {
                        print(value);
                      }
                    },
                    items: <DropdownMenuItem>[
                      new DropdownMenuItem(
                        value: "edit",
                        child: new Text("edit"),
                      ),
                      new DropdownMenuItem(
                        value: "delete",
                        child: new Text("delete"),
                      ),
                    ],
                  ),
                )
              : new Expanded(
                  flex: 1,
                  child: new Container(),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.unfocus();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Comments",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 3.0,
      ),
      body: _isLoading
          ? new CircularProgressIndicator()
          : new Stack(
              children: <Widget>[
                new ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return new Container(
                      color: Colors.grey,
                      height: 2.0,
                    );
                  },
                  itemCount: _comments == null ? 0 : _comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCommentTile(index);
                  },
                ),
                new Align(
                  alignment: Alignment.bottomCenter,
                  child: new Container(
                    color: Colors.grey,
                    height: 60.0,
                    child: new Row(
                      children: [
                        new Expanded(
                          flex: 1,
                          child: widget.loggedInUser.image == null
                              ? new Container(
                                  decoration: new BoxDecoration(
                                      borderRadius:
                                          new BorderRadius.circular(40.0),
                                      border: new Border.all(
                                          width: 3.0, color: Colors.black)),
                                  child: new CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: new Image.asset(
                                        'assets/chat_Bot_Icon.png'),
                                  ),
                                )
                              : new Container(
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(40.0),
                                    border: new Border.all(
                                        width: 3.0, color: Colors.black),
                                  ),
                                  child: new CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: new FileImage(
                                      new File(widget.loggedInUser.image),
                                    ),
                                  ),
                                ),
                        ),
                        new Expanded(
                          flex: 8,
                          child: new TextField(
                            focusNode: myFocusNode,
                            autofocus: false,
                            style: new TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10.0,
                                color: Colors.black),
                            controller: _textController,
                            key: new Key(widget.tileId),
                            keyboardType: TextInputType.multiline,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: "Write A Comment",
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.brown,
                                    style: BorderStyle.solid,
                                    width: 2.0),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(40.0),
                                ),
                              ),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.brown,
                                    style: BorderStyle.solid,
                                    width: 2.0),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(40.0),
                                ),
                              ),
                              hintStyle: new TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new RaisedButton(
                            elevation: 2.0,
                            shape: new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.brown,
                                  width: 1.0,
                                  style: BorderStyle.solid),
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: new Text(
                              "submit",
                              style: new TextStyle(fontSize: 15.0),
                            ),
                            onPressed: () async {
                              String comment = _textController.text;
                              _textController.text = "";
                              myFocusNode.unfocus();
                              if (comment != "") {
                                String timeStamp =
                                    (new DateTime.now().millisecondsSinceEpoch)
                                        .toString();
                                await CommentsRepo().insertAComment(
                                    widget.tileId,
                                    timeStamp,
                                    widget.loggedInUser.id,
                                    comment);

                                
                                _initCommentData();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
