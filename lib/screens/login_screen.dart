import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maui/components/user_list.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';

import 'tab_home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return new _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  List<User> _users;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    new UserRepo().getUsers().then((users) {
      setState(() {
        _users = users;
        _isLoading = false;
      });
    });
  }

  getImage(BuildContext context) async {
//    var _fileName = await ImagePicker.pickImage(
//        source: ImageSource.camera, maxHeight: 128.0, maxWidth: 128.0);
//    var user = await new UserRepo()
//        .insert(new User(image: _fileName.path, currentLessonId: 1));
//    AppStateContainer.of(context).setLoggedInUser(user);
    Navigator.of(context).pushNamed('/camera');
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = AppStateContainer.of(context).state.loggedInUser;
    return loggedInUser != null
        ? new TabHome()
        : new Scaffold(
            body: _isLoading
                ? new SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: new CircularProgressIndicator(),
                  )
                : (_users?.length ?? 0) == 0
                    ? new Container()
                    : new UserList(users: _users),
            floatingActionButton: new FloatingActionButton(
              key: new ValueKey('add-user'),
              child: new Icon(Icons.add),
              onPressed: () => getImage(context),
            ),
          );
  }
}
