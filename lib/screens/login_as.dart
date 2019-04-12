import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';

class LoginAs extends StatefulWidget {
  @override
  _LoginAsState createState() => new _LoginAsState();
}

class _LoginAsState extends State<LoginAs> {
  List<User> users;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _initData();
  }

  void _initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await UserRepo().getUsers().then((futureData) {
        setState(() {
          users = futureData;
          _isLoading = false;
        });
      });
    });
  }

  Widget renderGridView(List<User> _users) {
    return GridView.count(
        padding: EdgeInsets.all(2.0),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: List.generate(_users.length, (index) {
          return new GestureDetector(
              onTap: () {
                print("Hello World..!!");
              },
              child: Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                  child: Center(child: new Text("${_users[index].name}"))));
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && users == null) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("Login As"),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  flex: 2,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Teachers",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: renderGridView(users),
                      ),
                    ],
                  ),
                ),
                new Divider(
                  color: Colors.black,
                  height: 2.0,
                ),
                new Expanded(
                  flex: 2,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Students",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: renderGridView(users),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
